import json
import os
import argparse

def extract_strings(file_path):
    with open(file_path, 'r') as f:
        json_data = json.load(f)
        if 'strings' not in json_data:
            raise ValueError("Invalid JSON format: 'strings' key not found")
        
        strings_data = json_data['strings']
        strings = {}
        
        for key, value in strings_data.items():
            if 'localizations' in value:
                localizations = value['localizations']
                for lang, lang_data in localizations.items():
                    if 'stringUnit' in lang_data:
                        value = lang_data['stringUnit'].get('value', '')
                        strings[key] = value
                        break
            else:
                strings[key] = ""
                
        return strings

def generate_swift_class(strings):
    swift_code = "//\n//  This file is auto generated from the strings catalog by strings.py\n//\n\n"
    swift_code += "import Foundation\n"
    swift_code += "import SwiftUI\n\n"
    swift_code += "struct Strings {\n\n"
    
    for key, value in strings.items():
        if value == None: 
            continue
        args = []

        words = key.split()
        key_name = words[0] + ''.join(word.title() for word in words[1:])
        
        # Find parameters in the value
        start = value.find("%lld")
        arg_index = 0
        while start != -1:
            arg_index += 1
            end = start + 4
            arg_name = f"arg{arg_index}"
            args.append(arg_name)
            value = value[:start] + "\\(" + arg_name + ")" + value[end:]
            start = value.find("%lld")
        
        # Generate static property or static method based on parameters
        if len(args) > 0:
            swift_code += f"    static func {key}("
            swift_code += ', '.join(f"{arg}: String" for arg in args)
            swift_code += f") -> LocalizedStringResource {{ LocalizedStringResource(\"{key}\", defaultValue: \"{value}\") }}\n\n"
        else:
            swift_code += f"    static let {key_name}: LocalizedStringKey = \"{key}\"\n\n"

    swift_code += "}\n"
        
    return swift_code

def main():
    parser = argparse.ArgumentParser(description="Generate Swift class from .xcstrings file")
    parser.add_argument("-f", metavar="FILE_PATH", type=str, default="../Localization", help="Path to the .xcstrings file")
    args = parser.parse_args()

    dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(dir, args.f, "Localizable.xcstrings")

    if not os.path.isfile(file_path):
        print("Input file does not exist at %s" % file_path)
        return

    strings = extract_strings(file_path)
    swift_code = generate_swift_class(strings)

    output_path = os.path.join(os.path.dirname(file_path), "Strings.swift")
    with open(output_path, "w") as f:
        f.write(swift_code)
    print("Swift.strings generated successfully with %s definitions!" % len(strings.keys()))

if __name__ == "__main__":
    main()
