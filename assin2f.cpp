/* This program was created in a UNIX environment.  Sorry I forgot to 
e-mail this to you. */

#include <iostream>
#include <fstream>			
#include <ctype.h>

using namespace std;

ifstream data;

//int count;
double total = 0;
double totala;
double ave;

int main(){
	data.open("data.txt");
	int count = 0;
	while(!!data){
		count++;
		data >> totala;
		total = total + totala;
	};	
	ave = total/count;
	cout << "Sum " << total << endl << "Average " << ave << endl;
	
 	data.close();

};
