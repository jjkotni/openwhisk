import json
import pickle
import os

def main(event):
    print(os.system('nvidia-smi'))
    # print('Hello World!')
    result = {'body':'yoyo'}
    return result
