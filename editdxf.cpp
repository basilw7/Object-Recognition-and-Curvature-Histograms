/* This program was created in a Unix environment 
comments can be removed to see each step */

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

ifstream data;
ifstream data1;
ifstream doc;
ofstream errors;
string *words;


int num_elements(){
	data.open("sample.txt");
	string word;
	int elements = -1;
	while(!!data){
		elements++;
		data >> word;
	};
	data.close();
	return (elements - 1);
};


void create_dxf(int a){
	cout << "Creating Document" << endl;
	data1.open("sample.txt");
	errors.open("1.dxf")
	words = new string[a];
	int i = -1;
	string temp;
	while( i < (a-1)){
		i++;
		data1 >> temp;
		if (temp == "0SECTION"){errors << endl << temp;}
		if (temp == "03FACE"){errors << endl << temp;)
		errors << temp;
		}
		if (i > a+1){cout << "error";};
	data1.close();
	cout << "DXF file created" << endl;
};

void verify_sorting(int t){
	for(int i = 0; i < (t - 1); i++){cout << i << " " << words[i] << endl;};
};

int main(){
	int a = num_elements();
	create_dxf(a)
	cout << "spell check is now finished errors can be found in a the errors.txt file" << endl;
	return 0;
};
