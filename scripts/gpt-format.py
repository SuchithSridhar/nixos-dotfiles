#!/usr/bin/env python3

import argparse
import os
import sys
from openai import OpenAI


def split_into_chunks(text, max_words=2000):
    paragraphs = text.split("\n\n")
    chunk = ""
    chunks = []

    for paragraph in paragraphs:
        if len(chunk.split()) + len(paragraph.split()) <= max_words:
            chunk += paragraph + "\n\n"
        else:
            if chunk:
                chunks.append(chunk.strip())
            if len(paragraph.split()) > max_words:
                raise ValueError("Paragraph exceeds the maximum word count: "
                                 f"{paragraph[:100]}...")
            chunk = paragraph + "\n\n"

    if chunk:
        chunks.append(chunk.strip())

    return chunks


SYSTEM_GOAL = "You are a writing assistant specialized in correcting grammar, \
sentence formation, factual, and other writing issues in text. Fix all the \
error in the provided file. Your output should only contain contents of the \
file. Maintain the text width of the file to be 80 characters."


def process_files(file_list, client, model_name, context, start_line=None, end_line=None, output=None, verbose=False):
    for filename in file_list:
        try:
            with open(filename, 'r', encoding='utf-8') as file:
                lines = file.readlines()

            before_process = ''.join(
                lines[:start_line - 1]) if start_line is not None else ''
            to_process_start = start_line - 1 if start_line is not None else 0
            to_process_end = end_line if end_line is not None else len(lines)
            to_process = ''.join(lines[to_process_start:to_process_end])
            after_process = ''.join(
                lines[to_process_end:]) if end_line is not None else ''

            chunks = split_into_chunks(to_process)
            corrected_text = ""

            system_content = SYSTEM_GOAL

            if context:
                system_content += "\n Additional Context: " + context

            if verbose:
                print(f"{len(chunks)} chunks to process...", file=sys.stdout)

            for index, chunk in enumerate(chunks, start=1):
                if verbose:
                    print(f"Processing chunk {index}.", file=sys.stdout)
                response = client.chat.completions.create(
                    model=model_name,
                    messages=[
                        {"role": "system", "content": system_content},
                        {"role": "user", "content": chunk}
                    ]
                )
                corrected_text += response.choices[0].message.content + "\n\n"

            full_text = before_process + corrected_text.strip() + after_process

            if output == "stdout":
                print(full_text)
            else:
                base, ext = os.path.splitext(filename)
                output_filename = f'{base}.gpt{ext}' if output is None else output

                with open(output_filename, 'w', encoding='utf-8') as output_file:
                    output_file.write(full_text)

                if verbose:
                    print(
                        f'Processed {filename} -> {output_filename}', file=sys.stdout)
        except Exception as e:
            print(f'Error processing {filename}: {e}', file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(
        description='Correct text files using OpenAI API.')
    parser.add_argument('files', metavar='FILE', type=str,
                        nargs='+', help='Files to process')
    parser.add_argument('--model', type=str, default='3.5',
                        help='Model version (3.5 or 4)')
    parser.add_argument('--context', type=str, default='',
                        help='Additional context for text correction')
    parser.add_argument('--start-line', type=int, default=None,
                        help='Starting line number for text processing')
    parser.add_argument('--end-line', type=int, default=None,
                        help='Ending line number for text processing')
    parser.add_argument('--output', type=str, default=None,
                        help='Output file name, or "stdout" for console output')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Enable verbose output')

    args = parser.parse_args()

    if not args.files:
        sys.exit('Error: No files provided.')

    model_versions = {
        '3.5': 'gpt-3.5-turbo-0125',
        '4': 'gpt-4-turbo'
    }

    model_name = model_versions.get(args.model)
    if not model_name:
        sys.exit(
            f'Error: Invalid model version {args.model}. Use "3.5" or "4".')

    client = OpenAI(
        organization='org-bJux85K8yd0H6yesaJ8LyTEn',
        api_key=os.environ.get("OPENAI_API_KEY")
    )

    process_files(args.files, client, model_name, args.context,
                  args.start_line, args.end_line, args.output, args.verbose)


if __name__ == '__main__':
    main()
