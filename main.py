'''
    # Colab 환경 : 모델 GET : file을 로드 *.h5
    1) 저장 : url to file
    2) 압축해제 : zip extract
    3) 모델 load

    # python 실행환경 : file 에서 모델을 load하면됨
'''

import urllib.request
import zipfile
from keras.models import load_model
import numpy as np
import pandas as pd
import sys

def get_model():

    # git hub 에서 file download
    url = 'https://raw.githubusercontent.com/kiakass/share/master/logistics_suggest_cost_240426.zip'
    savename = "/content/logistics_suggest_cost_240426.zip"

    mem = urllib.request.urlopen(url).read()

    with open(savename, 'wb') as f:
        f.write(mem)

    urllib.request.urlretrieve(url,savename)

    path_to_zip_file = "/content/logistics_suggest_cost_240426.zip"
    directory_to_extract_to = '/content/'

    with zipfile.ZipFile(path_to_zip_file, 'r') as zip_ref:
        zip_ref.extractall(directory_to_extract_to)

# url download & unzip
get_model()
model = load_model('/content/logistics_suggest_cost_240426.h5')

# 수행 - input : n 개
def run(X):
    predict=model.predict(X, verbose=0)
    return X, predict

if __name__ == '__main__':
    # input : ['ton','distance'], 다중수행/배열
    X = np.array(list(map(float, sys.argv[1:])))
    # run
    X, predict = run(X.reshape(-1,2))
    # 출력
    print(predict.round().reshape(-1))
    
