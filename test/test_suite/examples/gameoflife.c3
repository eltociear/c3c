module game_of_life;

extern fn void printf(char *fmt, ...);
extern fn int atoi(char *val);
extern void *__stdoutp;
extern fn void fflush(void *std);
extern fn int rand();
extern fn void* malloc(usz size);
extern fn void usleep(int time);


struct GameBoard
{
    int h;
    int w;
    char* world;
    char* temp;
}

fn void GameBoard.show(GameBoard *board)
{

	printf("\e[H");
	char* current = board.world;
	for (int y = 0; y < board.h; y++)
	{
	    for (int x = 0; x < board.w; x++)
	    {
	        printf(*current ? "\e[07m  \e[m" : "  ");
	        current++;
	    }
		printf("\e[E");
	}
	fflush(__stdoutp);
}

fn void GameBoard.evolve(GameBoard *board)
{
	for (int y = 0; y < board.h; y++)
	{
	    for (int x = 0; x < board.w; x++)
	    {
    		int n = 0;
    		for (int y1 = y - 1; y1 <= y + 1; y1++)
	    	{
		        for (int x1 = x - 1; x1 <= x + 1; x1++)
		        {
		            int actualX = (x1 + board.w) % board.w;
		            int actualY = (y1 + board.h) % board.h;
		            if (board.world[actualX + actualY * board.w]) n++;
		        }
		    }
		    if (board.world[x + y * board.w]) n--;
            board.temp[x + y * board.w] = (char)(n == 3 || (n == 2 && board.world[x + y * board.w]));
	    }
	}
	for (int i = 0; i < board.w * board.h; i++)
	{
	    board.world[i] = board.temp[i];
	}
}


fn int main(int c, char** v)
{
	int w = 0;
	int h = 0;
	if (c > 1) w = atoi(v[1]);
	if (c > 2) h = atoi(v[2]);
	if (w <= 0) w = 30;
	if (h <= 0) h = 30;

    GameBoard board;
    board.w = w;
    board.h = h;
    board.world = malloc(h * w);
    board.temp = malloc(h * w);

    for (int i = h * w - 1; i >= 0; i--)
    {
        board.world[i] = rand() % 10 == 0 ? 1 : 0;
    }
    for (int j = 0; j < 1000; j++)
	{
		board.show();
		board.evolve();
		usleep(200000);
	}
	return 1;
}