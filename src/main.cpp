#include <iostream>
#include "Poco/MD5Engine.h"
#include "Poco/DigestStream.h"
#include "MyApp/Foo.h"
#include "MyLibrary/Foo.h"

using namespace std;

string GeneratePocoMd5Hex()
{
    Poco::MD5Engine md5;
    Poco::DigestOutputStream ds(md5);
    ds << "abcdefghijklmnopqrstuvwxyz";
    ds.close();
    return Poco::DigestEngine::digestToHex(md5.digest());
 }

int main(int argc, char** argv)
{
    cout << "Hello, World!" << endl;

    MyApp::Foo myAppFoo;
    cout << "MyApp::Foo=" << myAppFoo.GenerateNumber() << endl;

    MyLibrary::Foo myLibraryFoo;
    cout << "MyLibrary::Foo=" << myLibraryFoo.GenerateNumber() << endl;

    string md5Hex = GeneratePocoMd5Hex();
    cout << "Poco::MD5::Hex=" << md5Hex << endl;
    return 0;
}
