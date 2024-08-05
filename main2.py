'''
    # Colab 환경 : 모델 GET : file을 로드 *.h5, *.kerase
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

# 변수로 파일 이름 처리
filename = 'logistics_suggest_4_510200_2024080506.zip'
model_filename = 'logistics_suggest_4_510200_2024080506.keras'
url = f'https://raw.githubusercontent.com/kiakass/share/master/{filename}'
savename = f"/content/{filename}"
path_to_zip_file = savename
directory_to_extract_to = '/content/'
model_path = f'/content/{model_filename}'

def get_model():
    # GitHub에서 파일 다운로드
    mem = urllib.request.urlopen(url).read()

    with open(savename, 'wb') as f:
        f.write(mem)

    urllib.request.urlretrieve(url, savename)

    with zipfile.ZipFile(path_to_zip_file, 'r') as zip_ref:
        zip_ref.extractall(directory_to_extract_to)

# URL에서 파일 다운로드 및 압축 해제
get_model()

# 모델 로드
model = load_model(model_path)

# 예측 수행 함수 - input : n 개
def run(X):
    predict = model.predict(X, verbose=0)
    return X, predict

if __name__ == '__main__':
    # input : ['ton','distance'], 다중수행/배열
    X = np.array(list(map(float, sys.argv[1:])))
    # run
    X, predict = run(X.reshape(-1,2))
    # 출력
    print(predict.round().reshape(-1))
    
