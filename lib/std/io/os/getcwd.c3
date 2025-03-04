module std::io::os;
import libc;

$if (env::OS_TYPE == OsType.WIN32):

extern fn Char16* _wgetcwd(Char16* buffer, int maxlen);
extern fn usz wcslen(Char16* str);

macro char[]! getcwd(Allocator* allocator = mem::default_allocator())
{
	const DEFAULT_BUFFER = 256;
	Char16[DEFAULT_BUFFER] buffer;
	Char16 *res = _wgetcwd(&buffer, DEFAULT_BUFFER);
	bool free = false;
	defer if (free) libc::free(res);
	if (!res)
	{
	    if (libc::errno() != errno::ERANGE) return IoError.GENERAL_ERROR!;
		res = _wgetcwd(null, 0);
		free = true;
	}
	Char16[] str16 = res[:wcslen(res)];
	return str::utf16to8(str16, allocator);
}

$else:

extern fn ZString _getcwd(char* pwd, usz len) @extname("getcwd");
macro char[]! getcwd(Allocator* allocator = mem::default_allocator())
{
	const usz DEFAULT_BUFFER = 256;
	char[DEFAULT_BUFFER] buffer;
	ZString res = _getcwd(&buffer, DEFAULT_BUFFER);
	bool free = false;
	if (!res)
	{
		// Improve error
		if (libc::errno() != errno::ERANGE) return IoError.GENERAL_ERROR!;
		res = _getcwd(null, 0);
		free = true;
	}
	defer if (free) libc::free((void*)res);
	char[] copy = str::copyz(res.as_str(), allocator);
	return copy;
}

$endif;