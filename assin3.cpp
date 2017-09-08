/* This program can handle a dictionary with the maximum of 500 words of the size 20 characters each 
comments can be removed to view output from each step
*/
#include <iostream>
#include <fstream>
#include <string>


using namespace std;

ifstream data;
ifstream doc;
ofstream errors;

int elements = -1;
char word[500][20];
int where[500];
string a1;
string b1;
int count;
void main(){
	data.open("dictionary.txt");
	while(!!data){
		elements++;
		data >> word[elements];
		cout << elements << " " << word[elements] << endl;
		where[elements] = elements;
	};
	elements;	// careful!!!
	cout << elements << endl;

	bool swap = true;
	int temp;
//	count = 0;
	while(swap){
//		for(int u=0; u < elements; u++){cout << word[where[u]] << " ";};
//		cout << endl;
//		for(int y=0; y < elements; y++){cout << where[y] << " ";};
//		cout << endl;
//		count++;
//		cout << "                                  pass #" << count << endl;
		swap = false;
		for (int a = 0; a < (elements-1) ; a++){
			a1 = word[where[a]];
			b1 = word[where[a + 1]];
			cout << a1 << " " << b1 << endl;
			cout << where[a] << " " << where[a+1]<< endl;
			if (a1 > b1){
				temp = where[a];
				where[a] = where[a + 1];
				where[a + 1] = temp;
				swap = true;
//				cout << "not fine" << endl;
//				cout << "a swap done" << endl;
//				cout << where[a] << " " << where[a+1]<< endl;
				}
			if (a1 < b1){
//				cout << "fine" << endl;

		
			};
		};
	};
	cout << "sorting done" << endl;
	cout << "words are in order" << endl;
//	for(int a=0; a < elements; a++){cout << word[where[a]] << " " << where[a] << endl;};
	data.close();
	doc.open("document.txt");
	errors.open("errors.txt");
	bool exit;
	int b;
	while(!!doc){
		int a = (elements-1)/2 - 1;
		b = elements;
		doc >> a1;
		cout << "word currently being checked " << a1 << endl;
		exit = false;
		while(!exit){
//			cout << a << " " << b << endl;
//			cout << a1 << " " << b1 << endl;
			b1 = word[where[a]];
			if (a1 == b1){
				cout << "Word found" << endl;
				exit = true;
			}
			if ((a1 < b1) && (!exit)){
				b = a;	
				a = (a/2);
				if ((a - b) == 0){
					cout << "word not found" << endl;
					errors << a1 << " ";
					exit = true;
//					cout << "less" <<endl;
				}
			}
			if ((a1 > b1) && (!exit)){
				a = a + (b - a)/2;
				if ((b-a) == 1){a++;};
				cout << a << endl;
				if ((a >= elements) || ((a - b) == 0)){
					cout << "word not found" << endl;
//					cout << " more" << endl;
					errors << a1 << " ";
					exit = true;

				}
			}
	
		};
	};
	cout << "spell check is now finished errors can be found in a the errors.txt file" << endl;
};
