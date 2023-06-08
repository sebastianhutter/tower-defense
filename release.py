import requests
import json
import os
import pathlib
import click

# GitHub repository details
owner = 'sebastianhutter'
repo = 'tower-travel'

# GitHub access token with "repo" scope
access_token = os.getenv('PAT')
releases_url =  f'https://api.github.com/repos/{owner}/{repo}/releases'
headers = dict(
    Authorization=f'Bearer {access_token}'
)


@click.command()
@click.option('--name', help='Name of the release', required=True)
@click.option('--pre-release/--no-pre-release', default=False, help='Whether the release is a pre-release')
def main(name: str, pre_release: bool): 
    """create or update github releases"""
    # Release details
    tag_name = os.getenv('TAG_NAME')
    release_name = tag_name

    # create the release
    payload=dict(
        tag_name=name,
        name=name,
        generate_release_notes=True,
        prerelease=pre_release,

    )
    response = requests.post(url=releases_url, headers=headers, json=payload)

    # upload builds to release
    assets_url = f'https://uploads.github.com/repos/{owner}/{repo}/releases/{response.json()["id"]}/assets'
    for item in pathlib.Path('build').glob('**/*'):
        if item.is_file():
            with open(item, "rb") as f:
                response = requests.post(url=f'{assets_url}?name={item.name}', headers={**headers, **{'Content-Type': 'application/octet-stream'}}, data=f.read()) 
                if response.status_code == 201:
                    print("File uploaded successfully!")
                else:
                    print(f"Failed to upload file: {response.text}")


if __name__ == '__main__':
    main()