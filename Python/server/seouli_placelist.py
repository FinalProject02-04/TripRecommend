from fastapi import APIRouter
import pandas as pd
import numpy as np

# Server Host IP
host_ip = '192.168.50.83'

router = APIRouter()

@router.get("/list")
async def placeLists() :
    df = pd.read_csv("./data/구석구석_정제.csv")

    # 총 데이터 4000개가 너무 많은 것 같아서 일단 강남구만 추렸습니다.
    df = df[df.sigungu == "강남구"]

    result_arr = []
    for i in range(len(df)) :
        result_arr.append(df.iloc[i, :5].to_dict())

    return result_arr


@router.get("/recommend")
async def recommendLists(input: str) :
    from sklearn.feature_extraction.text import TfidfVectorizer
    df = pd.read_csv("./data/tfidf_df.csv")

    tfidf = TfidfVectorizer()
    tfidf_matrix = tfidf.fit_transform(df['정보'])

    result_cosine_similarity = user_input_to_cosine_sim(tfidf, tfidf_matrix, complete_sentence(input))
    top_index = np.argsort(result_cosine_similarity)[::-1]

    result_arr = []

    for row in top_index[:5]:
        if result_cosine_similarity[row] <= 0 :
            break
        name = df.loc[row, '장소명']
        result_arr.append(searchByName(name))
    
    return result_arr


# 사용자의 입력문장을 통한 코사인 유사도 계산
def user_input_to_cosine_sim(model, tfidf_matrix, query) :
    from sklearn.metrics.pairwise import cosine_similarity
    from konlpy.tag import Komoran
    ko = Komoran()

    query = ' '.join(ko.nouns(query))
    query_tfidf = model.transform([query])
    cosine_sim = cosine_similarity(query_tfidf, tfidf_matrix).reshape(-1)
    return cosine_sim

def searchByName(place_name) :
    df = pd.read_csv("./data/구석구석_정제.csv")
    find_df = df.loc[df.name == place_name]
    return find_df.iloc[0,:5].to_dict()

def translate_to_korean(input) :
    from googletrans import Translator
    translator = Translator()
    return translator.translate(input, src=translator.detect(input).lang, dest="ko").text

def complete_sentence(input_sent) :
    import re
    # 정규식 패턴
    en_pattern = re.compile('[a-zA-Z]+')
    ko_pattern = re.compile('[ㄱ-ㅎ가-힣]+')

    result_sent = ""
    for word in input_sent.split(' ') :
        temp_word = ""
        # 1. 한국어와 영어 구분
        try :
            if ko_pattern.findall(word)[0] == word:
                # print("한국어만 존재하는 단어")
                temp_word = word

            else :
                # 2. 한국어와 영어가 둘다 존재하는 단어 => 분리해야함
                # print("영어와 한국어가 존재하는 단어")
                ko_word = ()
                en_word = ()
                for i in ko_pattern.finditer(word) :
                    ko_word = i.start(), i.group()

                for j in en_pattern.finditer(word) :
                    en_word = j.start(), j.group()

                # print("번역 문장 ---", en_word[1])
                en_word_to_ko = translate_to_korean(en_word[1])

                temp_word = (ko_word[1] + en_word_to_ko) if (ko_word[0] < en_word[0]) else (en_word_to_ko+ko_word[1])

        # 영단어는 한국어 정규식에 포함되지 않으므로 배열 자체가 비어있음 => []
        except :
            # print("영어만 존재하는 단어")
            temp_word = translate_to_korean(word)
        finally :
            result_sent += temp_word + " "
    
    return result_sent