#include <iostream>
#include <fstream>			
#include <ctype.h>

using namespace std;

ifstream data;


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
		cout << " totala " << totala << " total " << total << " data " << 
data << endl << endl;
	};	
	ave = total/count;
	cout << "Sum " << total << endl << "Average " << ave << endl;
	
 	data.close();

};
