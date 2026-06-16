#include <string>
#include "CLI/CLI.hpp"
#include "fmt/core.h"
#include "openssl/md5.h"
#include "MyApp/Foo.h"
#include "MyLibrary/Foo.h"

using namespace fmt;
using namespace std;

#define ERGONOMIC_CPP_APP_NAME "1.0.0"
#define ERGONOMIC_CPP_APP_VERSION "1.0.0"

void BuildCommandParser(CLI::App& app);
string GenerateMd5Hex();

int main(int argc, char** argv)
{
    print("Hello, World!\n");

    MyApp::Foo myAppFoo;
    print("MyApp::Foo={}\n", myAppFoo.GenerateNumber());

    MyLibrary::Foo myLibraryFoo;
    print("MyLibrary::Foo={}\n", myLibraryFoo.GenerateNumber());

    string md5Hex = GenerateMd5Hex();
    print("MD5::Hex={}\n", md5Hex);

    CLI::App app;
    BuildCommandParser(app);
    CLI11_PARSE(app, argc, argv)

    auto&& options = app.get_options();
    print("CLI::App::Options={}\n", options.size());
    for (auto&& option : options)
        print("{}\n", option->get_name());
    return 0;
}

void BuildCommandParser(CLI::App& app)
{
    app.name(ERGONOMIC_CPP_APP_NAME);
    app.set_version_flag("--version", ERGONOMIC_CPP_APP_VERSION);
    app.allow_extras(true);

    int count = 0;
    app.add_option("-c,--count", count, "Counter");

    double value = 0.0;
    app.add_option("-d,--double", value, "Some Value");

    // NOTE: Passing an int as the flag value causes memory corruption in the CLI::App object.
    bool flag = false;
    app.add_flag("--flag", flag, "Some flag that can be passed multiple times");
}

string GenerateMd5Hex()
{
    const string input = "abcdefghijklmnopqrstuvwxyz";
    unsigned char digest[MD5_DIGEST_LENGTH];
    MD5(reinterpret_cast<const unsigned char*>(input.data()), input.size(), digest);

    string hex;
    for (unsigned char byte : digest)
        hex += fmt::format("{:02x}", byte);
    return hex;
}
