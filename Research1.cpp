#include <iostream>
#include <fstream>			
#include <ctype.h>

using namespace std;

ifstream instance;
ofstream prototype;

int add_knowledge(){
	prototype.open("scans.txt");
	prototype.close();
	return 0;
}; 

int anaylize_piece(int* scan_data){
	return 0;
};

int main(){
	char* text;
	cout << "choose data to examine" << endl;
	cin >> text;
	instance.open("sample.txt");	
 	instance.close();

};
