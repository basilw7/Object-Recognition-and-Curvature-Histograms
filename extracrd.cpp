/* This program was created in a Unix environment 
order of accounts balance, 
comments can be removed to see each step */

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

ifstream text;
ofstream change;

string *name;
string *account_info;

bool exit1 = false;


int messages(int a){
	switch (a){
	default: cout << "message error" << endl;
	case 1:{
		cout << "Welcome to ebank" << endl;
		cout << "Please choose from one of the following" << endl;
		cout << "1 Make a deposit " << endl 
			<< "2 Make a withdrawl" << endl 
			<< "3 Open an account" << endl 
			<< "4 Close an account" << endl;
		   };
	case 2: cout << "Please enter name" << endl;
	case 3: cout << "Enter PIN" << endl;
	case 4: cout << "Enter dollar amount" << endl;
	case 5: cout << "Thank you for choosing Ebank" << endl;
	case 6: cout << "Sorry to see you go" << endl;
	};
	return 0;
};

int whereis(string word, char *file){
	text.open(file);
	int a;
	string temp;
	int i = -1;
	while(!!text){
		i++;
		text >> temp;
		if (word == temp){a = i;};
	};
	text.close();
	return a;
};

string load(int a, char *file){
	cout << "loading" << endl;
	text.open(file);
	bool found = false;
	string temp;
	string temp2;
	int i = -1;
	while( i < (a-1)){
		i++;
		text >> temp;
		if (i == a){temp2 = temp;};
		}
	if (found == true){
		return temp;}
	else{
		return "error";};
	text.close();
	cout << "information loaded" << endl;
};


double loadnum(int a, char *file){
	cout << "loading" << endl;
	text.open(file);
	bool found = false;
	double temp;
	double temp2;
	int i = -1;
	while( i < (a-1)){
		i++;
		text >> temp;
		if (i == a){temp2 = temp;};
	};
	cout << "information loaded" << endl;
	if (found == true){
		return temp2;}
	else {
		return 0;
	};
	text.close();
};

int write(double a, int i){
	bool quit = false;
	int b=0;
	text.open("account.txt");
	change.open("temp");
	int garbage;
	while(!!text && !quit){
		b++;
		if (i == b){
			text >> garbage;
			change << a;
		}
		else
			 change << text ;
		if (b <= 5000){quit = true;};
	};
	text.close();
	change.close();
	change.open("account.txt");
	text.open("temp");
	quit = false;
		while(!!text && !quit){
			 change << text ;
		if (b <= 5000){quit = true;};
	};
	return 0;
};

int twrite(char *a, int i){
	bool quit = false;
	int b=0;
	text.open("clients.txt");
	change.open("temp");
	int garbage;
	while(!!text && !quit){
		b++;
		if (i == b){
			text >> garbage;
			change << a;
		}
		else
			 change << text ;
		if (b <= 5000){quit = true;};
	};
	text.close();
	change.close();
	change.open("clients.txt");
	text.open("temp");
	quit = false;
		while(!!text && !quit){
			 change << text ;
		if (b <= 5000){quit = true;};
	};
	return 0;
};

int deposit(){
	string tempN;
	string tempPW;
	double balance;
	double requested;
	int pos;
	messages(2);
	cin >> tempN;
	messages(3);
	cin >> tempPW;
	pos = whereis(tempN,"clients.txt");
	if (tempPW == load(pos,"passwords.txt") ){
		balance = loadnum(pos,"accounts.txt");
		messages(4);
		cin >> requested;
		if ((requested <= 0)){
			cout << "invalid dollar amount"<< endl;}
		else {
			balance =  balance + requested;
			cout << "remaining " << balance << endl;
			write(balance,pos);
		}
	}
	return 0;
};

int withdrawl(){
	string tempN;
	string tempPW;
	double balance;
	double requested;
	int pos;
	messages(2);
	cin >> tempN;
	messages(3);
	cin >> tempPW;
	pos = whereis(tempN,"clients.txt");
	if (tempPW == load(pos,"passwords.txt") ){
		balance = loadnum(pos,"accounts.txt");
		messages(4);
		cin >> requested;
		if ((requested <= 0) || (requested > balance)){
			cout << "invalid dollar amount"<< endl;}
		else {
			balance =  balance - requested;
			cout << "remaining " << balance << endl;
			write(balance,pos);
		}
	}
	return 0;
};

// start here 

int add(string a, string b){
	string tempN = a;
	//append name
	string tempPW = b;
	//append PIN
	//append account
	return 0;
};


int Oaccount(){
	string tempN;
	string tempPW;
	messages(2);
	cin >> tempN;
	cout << "We need to create a personal identification number" << endl;
	messages(3);
	cin >> tempPW;
	add(tempN,tempPW);
	messages(5);
	return 0;
};


int Caccount(){
	string tempN;
	string tempPW;
	double balance;
	int pos;
	messages(2);
	cin >> tempN;
	messages(3);
	cin >> tempPW;
	pos = whereis(tempN,"clients.txt");
	if (tempPW == load(pos,"passwords.txt") ){
		balance = loadnum(pos,"accounts.txt");
		if (balance == 0){
			write(0,pos);
		}
	}
	messages(6);
	return 0;
};


int action(int a){
	switch (a){
	case 0: exit1 = true;
	case 1: deposit();
	case 2: withdrawl();
	case 3: Oaccount();
	case 4: Caccount();
	default: cout << "that is not a valid responce " << endl;
	}
	return 0;
};





int main(){
	cout << "enter zero to quit from anywhere" << endl;
	while(!exit1){
		int choice;
		messages(1);
		cin >> choice;
		action(choice);
	};

	return 0;

};
