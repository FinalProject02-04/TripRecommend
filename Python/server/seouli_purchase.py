from fastapi import APIRouter
import pymysql
from datetime import datetime

"""
작성자 : 원도현
날짜 : 24.06.28 (금)
설명 : FastAPI를 사용하여 MySQL 데이터베이스의 'purchase' 테이블을 관리하는 Server
/select로 purchase 테이블을 불러옴   (패키지 리스트 불러오기)
/insert로 purchase 테이블을 insert (패키지 예약)
/update로 purchase 테이블의 pur_status를 update (패키지 예약 취소)
"""

router = APIRouter()

def connect():
    # MySQL Connection
    conn = pymysql.connect(
        host="192.168.50.83",
        user="root",
        passwd="qwer1234",
        db="seouli",
        charset="utf8"
    )
    return conn

# 192.168.50.83:8000/purchase/select
@router.get("/select")
async def pur_select():
    print("-------------------------------------- purchase select")
    conn = connect()
    curs = conn.cursor()

    sql = "SELECT * FROM purchase"

    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    dict_list = []
    for row in rows:
        dict_list.append(
            {
                'pur_id' : row[0],
                'pack_id' : row[1],
                'user_id' : row[2],
                'pur_date' : row[3],
                'pur_status' : row[4]
            }
        )
    return dict_list

# 192.168.50.83:8000/purchase/select/user?user_id=
@router.get("/select/user")
async def pur_user_select(user_id: str) :
    try :
        conn = connect()
        curs = conn.cursor()
        
        sql = "select pack.*, pur.pur_date, pur.pur_id from purchase as pur, package as pack where user_id = %s and pur_status = 1 and pur.pack_id = pack.pack_id"
        curs.execute(sql, user_id)
        rows = curs.fetchall()
        conn.close()

        result = []

        for data in rows :
            temp_dict = {
                "package_info" : make_dict(data),
                "purchase_date" : datetime.strftime(data[9], "%Y-%m-%d"),
                "pur_id" : data[10]
            }
            result.append(temp_dict)

        return result
    except :
        print("Error")
        return "Error"

# 192.168.50.83:8000/purchase/insert?pack_id=&user_id=
@router.get("/insert")
async def pur_insert(pack_id: str, user_id: str):

    conn = connect()
    curs = conn.cursor()

    try:
        sql="insert into purchase(pack_id, user_id, pur_date, pur_status) values (%s, %s, now(), %s)"
        curs.execute(sql, (pack_id, user_id, 1))
        conn.commit()
        conn.close()
        return "Success"
    
    except Exception as ex:
        conn.close()
        print("Error :", ex)
        return "Error"

# 192.168.50.83:8000/purchase/update?pur_id=&status=
# 예약 취소
@router.get("/update")
async def pur_status_update(pur_id: int, status: int):
    conn = connect()
    curs = conn.cursor()

    try:
        sql="update purchase set pur_status=%s where pur_id=%s"
        curs.execute(sql, (status, pur_id))
        conn.commit()
        conn.close()
        return "Success"
    
    except Exception as ex:
        conn.close()
        print("Error :", ex)
        return "Error"


def make_dict(arr) :
    return {
        # pack_id
        "id" : arr[0],

        # pack_name
        "name" : arr[1],

        # pack_price
        "price" : arr[2],

        # pack_startdate,
        "startdate" : arr[3].strftime("%Y-%m-%d"),

        # pack_enddate
        "enddate" : arr[4].strftime("%Y-%m-%d"),

        # pack_trans
        "trans" : arr[5],

        # pack_tourlist
        "tourlist" : arr[6],

        # pack_stay
        "stay" : arr[7],

        "image" : arr[8]
    }
