#include <iostream>
#include <fstream>
#include "src/function.cpp"

int main() {

	int sizes = 359;
	char text[] = "\'It will not last,\' said O\'Brien. \'Look me in the eyes. What country is Oceania at war with?\'\r\nWinston thought. He knew what was meant by Oceania and that he himself was a citizen of Oceania. He also remembered Eurasia and Eastasia; but who was at war with whom he did not know. In fact he had not been aware that there was any war.\r\n'I don't remember.'\r\n'Oce"; 
	char unsigned coder[360];
	char key[8];

	cout << "Pls input key" << endl;
	cin >> key;

	RC4(key, text, coder);

	for(int i = 0; i < strlen(text); i++)
		printf("%02hhx", coder[i]);

	fstream file("rc4.img",ios::out|ios::in|ios::binary);

	int i = 0;
	while(file){
		if(file.get() == 0xff){
			if(i < sizes){
				file.seekp(-1, file.cur);
				file.put(coder[i]);
				file.flush();
			} else {
				file.seekp(-1, file.cur);
				file.put(0x00);
				file.flush();
			}
			
		i++;
		}
		

	}

	file.close();

	if(i > 0)
		cout << "\nSuccessful!" << endl;
	else cout << "\nBAD!" << endl;

	return 0;
}
