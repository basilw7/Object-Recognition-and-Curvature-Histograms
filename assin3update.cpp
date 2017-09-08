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
	data.open("dictionary.txt");
	string word;
	int elements = -1;
	while(!!data){
		elements++;
		data >> word;
	};
	data.close();
	return (elements - 1);
};




void load_dictionary(int a){
	cout << "loading dictionary" << endl;
//	cout << a << " words to be loaded" << endl;
	data1.open("dictionary.txt");
	words = new string[a];
	int i = -1;
	string temp;
	while( i < (a-1)){
		i++;
		data1 >> temp;
		words[i] = temp;
//		cout << "word loaded -> " << words[i] << endl;
		if (i > a+1){cout << "error";};
		}
	data1.close();
	cout << "dictionary loaded" << endl;
};


void sort_dictionary(int a){
	bool swap = true;
	string a1;
	string b1;
//	int count = 0;
	cout << "sorting begun" << endl;
	while(swap){
//		count++; cout << "pass #" << count << endl;
		swap = false;
		for (int b = 0; b < (a - 1) ; b++){
			a1 = words[b];
			b1 = words[b + 1];
			if (a1 > b1){
				words[b] = b1;
				words[b+1] = a1;
				swap = true;
			};
		};
//	cout << "sorting please wait" << endl;
	};
	cout << "sorting done" << endl;
};

void compare_words(int items){
	string a1;
	string b1;
	int highpos, lowpos;
	doc.open("document.txt");
	errors.open("errors.txt");
	bool exit;
	while(!!doc){
		int pos = items/2;
		highpos = items - 1;
		lowpos = 0;
		doc >> a1;
//		cout << "word currently being checked " << a1 << endl;
		exit = false;
		while(!exit){
			b1 = words[pos];
			if (a1 == b1){
//				cout << "Word found" << endl;
				exit = true;
			}
			if (!exit){
			if (pos == highpos  || pos == lowpos ){
//				cout << "word not found" << endl;
				errors << a1 << endl;
				exit = true;
			}
			}
			if ((a1 < b1) && (!exit)){
				highpos = pos;	
				pos =  ((pos - lowpos)/2);
			}
			if ((a1 > b1) && (!exit)){
				lowpos = pos;
				pos =  (pos + (highpos - pos)/2);
			}

		};
//		cout << "next word" << endl;
	};
	doc.close();
	errors.close();
	cout << "finished checking document" << endl;
};



void verify_sorting(int t){
	for(int i = 0; i < (t - 1); i++){cout << i << " " << words[i] << endl;};
};

int main(){
	int a = num_elements();
	load_dictionary(a);
	sort_dictionary(a);
//	verify_sorting(a);
	compare_words(a);
	cout << "spell check is now finished errors can be found in a the errors.txt file" << endl;
	return 0;
};
