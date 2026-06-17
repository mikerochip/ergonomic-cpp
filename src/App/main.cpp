#include <array>
#include <exception>
#include <string>
#include "CLI/CLI.hpp"
#include "fmt/core.h"
#include "openssl/md5.h"
#include "MyApp/Foo.h"
#include "MyLibrary/Foo.h"

using fmt::print;
using std::string;

constexpr auto* AppName = "1.0.0";
constexpr auto* AppVersion = "1.0.0";

namespace
{
    int Run(int argc, char* const* argv);
    void BuildCommandParser(CLI::App& app);
    string GenerateMd5Hex();
}  // namespace

int main(const int argc, char* const* argv)
{
    try
    {
        return Run(argc, argv);
    }
    catch (const std::exception& e)
    {
        print("Error: {}\n", e.what());
        return 1;
    }
}

namespace
{
int Run(const int argc, char* const* argv)
{
    print("Hello, World!\n");

    constexpr MyApp::Foo myAppFoo;
    print("MyApp::Foo={}\n", myAppFoo.GenerateNumber());

    print("MyLibrary::Foo={}\n", MyLibrary::Foo::GenerateNumber());

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
    app.name(AppName);
    app.set_version_flag("--version", AppVersion);
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
    std::array<unsigned char, MD5_DIGEST_LENGTH> digest{};
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-reinterpret-cast) -- bridge std::string's char data to the C MD5 API
    MD5(reinterpret_cast<const unsigned char*>(input.data()), input.size(), digest.data());

    string hex;
    for (unsigned char byte : digest)
        hex += fmt::format("{:02x}", byte);
    return hex;
}
}  // namespace
