#!/usr/bin/python3
# =============================================================
#
#   █████████   █████████
#  ███░░░░░███ ███░░░░░███  Suchith Sridhar
# ░███    ░░░ ░███    ░░░
# ░░█████████ ░░█████████   https://suchicodes.com
#  ░░░░░░░░███ ░░░░░░░░███  https://github.com/suchithsridhar
#  ███    ░███ ███    ░███
# ░░█████████ ░░█████████
#  ░░░░░░░░░   ░░░░░░░░░
#
# =============================================================
# A script to automatically upload notes
# to suchicodes.com when required.
# =============================================================
import os
import sys
import json
import requests

URL_ENDPOINT = 'https://suchicodes.com/api/admin/upload_blog'
CONFIG_FILE = 'suchicodes-config.json'
PASSWORD_FILE = '/home/suchi/.pass/suchicodes-pass'
REQUIRED_FIELDS = [
    'title', 'brief', 'category', 'markdown_file', 'pictures_dir'
]
DEFAULTS = {
    'markdown_file': 'notes.md',
    'pictures_dir': 'pic'
}

PAYLOAD = {
    'email': 'suchi',
}


def print_categories():
    def category_from_id(id_category, data):
        for item in data:
            if item['id'] == id_category:
                return item['name']

    category_url = "https://suchicodes.com/api/resources/categories"
    print("== Categories ==")
    data = json.loads(requests.get(category_url).text)
    sorted_ids = sorted([item['id'] for item in data])
    for index, _id in enumerate(sorted_ids):
        print(f"{_id}: {category_from_id(_id, data)}")


def check_data_json(json_data: dict):
    for field in REQUIRED_FIELDS + ['id']:
        if field not in json_data:
            return False
    return True


def fill_missing_data(json_data: dict):
    for field in REQUIRED_FIELDS:
        print("====")
        value = ''
        if (field == 'category'):
            print_categories()
            print()

        if field not in json_data and field in DEFAULTS:
            json_data[field] = DEFAULTS[field]

        if field not in json_data:
            while (value == ''):
                value = input(f'Enter a value for field \'{field}\': ')

        else:
            value = input(
                    f'Field \'{field}\':\n\t\'{json_data[field]}\'\nupdate: '
            )

        if (value != ''):
            json_data[field] = value


def load_from_config_file(config_file_path: str) -> dict:
    return json.load(open(config_file_path))


def set_password(payload):
    with open(PASSWORD_FILE) as f:
        data = f.read().strip()
    payload['password'] = data


def write_config_file(cwd, json_data):
    with open(os.path.join(cwd, CONFIG_FILE), 'w') as f:
        f.write(json.dumps(json_data, indent=4))


def send_to_suchicodes(cwd, json_data):
    files = []
    markdown = json_data['markdown_file']
    pic_dir = json_data['pictures_dir']
    config = CONFIG_FILE
    files.append((markdown, os.path.join(cwd, markdown)))
    files.append((config, os.path.join(cwd, config)))
    for file in os.listdir(pic_dir):
        path = os.path.join(os.path.join(cwd, pic_dir), file)
        if os.path.isfile(path):
            files.append((file, path))

    open_buffers = []
    for _, filepath in files:
        open_buffers.append(('files[]', open(filepath, 'rb')))

    payload = PAYLOAD
    set_password(payload)

    res_str = requests.post(
        URL_ENDPOINT,
        data=payload,
        files=open_buffers
    )

    try:
        response = json.loads(res_str.text)
    except json.decoder.JSONDecodeError:
        print("error in decoding json")
        print(res_str.text)
        exit(1)

    # Response status
    # failure: some error in 'error'
    # create: blog created, id in 'id'
    # update: blog updated, id in 'id'

    if (response['status'] == 'failure'):
        print(response['error'])
        exit(1)

    elif (response['status'] == 'create'):
        print(f"New blog created with ID: {response['id']}")
        json_data['id'] = response['id']
        write_config_file(cwd, json_data)

    elif (response['status'] == 'update'):
        print(f"Updated blog with ID: {response['id']}")

    else:
        print("Unknown status reported from suchicodes.com")
        exit(1)


def main():
    cwd = os.getcwd()

    if (len(sys.argv) >= 2 and
            (sys.argv[1] == '-s' or sys.argv[1] == '--skip-input')):
        skip_input = True
    else:
        skip_input = False

    if not skip_input:
        x = input(
            f'Are you sure you want to upload notes for directory:\n\'{cwd}\''
        )
        if (x != ''):
            exit(1)

    config_file_path = os.path.join(cwd, CONFIG_FILE)
    if (os.path.isfile(config_file_path)):
        json_data = load_from_config_file(config_file_path)
    else:
        json_data = {}

    if skip_input:
        valid = check_data_json(json_data)
        if not valid:
            print("Missing data in config file.")
            exit(1)
    else:
        fill_missing_data(json_data)
        write_config_file(cwd, json_data)

    _id = json_data.get('id', '')

    if not skip_input:
        if _id != '':
            print(f'Update blog with ID: \'{_id}\'?', end='')
        else:
            print('Create new blog?', end='')

        if input() != '':
            exit(1)

    send_to_suchicodes(cwd, json_data)


if __name__ == "__main__":
    main()
