#if !defined(CPP_FORMATTER)
#define CPP_FORMATTER

#include <iostream>
#include <sstream>
#include <string>
#include <vector>
#include <stdexcept>

/*
// Formatter for custom logging. WARING: Accepts %s format only
int main() {
    try {
        std::string result = Formatter::format("test %s", 1);
        std::cout << result << std::endl;

        result = Formatter::format("Hello, %s! The answer is %s.", "world", 42);
        std::cout << result << std::endl;
    } catch (const std::exception& ex) {
        std::cerr << "Error: " << ex.what() << std::endl;
    }

    return 0;
}
*/

class Formatter {
public:
    template<typename... Args>
    static std::string format(const std::string& format_str, Args... args) {
        std::vector<std::string> arg_strings = {Formatter::to_string(args)...};
        return vformat(format_str, arg_strings);
    }

    static std::string vformat(const std::string& format_str, const std::vector<std::string>& arg_strings) {
        std::ostringstream oss;
        size_t arg_index = 0;
        for (size_t i = 0; i < format_str.size(); ++i) {
            if (format_str[i] == '%' && i + 1 < format_str.size() && format_str[i + 1] == 's') {
                if (arg_index >= arg_strings.size()) {
                    throw std::runtime_error("Too few arguments provided for format string");
                }
                oss << arg_strings[arg_index++];
                ++i; // Skip 's'
            } else {
                oss << format_str[i];
            }
        }
        if (arg_index < arg_strings.size()) {
            throw std::runtime_error("Too many arguments provided for format string");
        }
        return oss.str();
    }

    template<typename T>
    static std::string to_string(const T& value) {
        std::ostringstream oss;
        oss << value;
        return oss.str();
    }
};

#endif // CPP_FORMATTER