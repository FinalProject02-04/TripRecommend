from fastapi import APIRouter
import pymysql
from datetime import datetime
import base64

# Server Host IP
host_ip = '192.168.50.83'

# MySQL Connection
def connect() :
    return pymysql.connect(
        host=host_ip,
        user='root',
        password='qwer1234',
        db='seouli',
        charset='utf8'
    )

router = APIRouter()

@router.get("/select")
async def packageTableSelect() :
    conn = connect()
    curs = conn.cursor()

    sql = "select * from package"
    curs.execute(sql)
    rows = curs.fetchall()

    curs.close()

    result = []

    for data in rows :
        temp_dict = {
            # pack_id
            "id" : data[0],

            # pack_name
            "name" : data[1],

            # pack_price
            "price" : data[2],

            # pack_startdate,
            "startdate" : data[3].strftime("%Y-%m-%d"),

            # pack_enddate
            "enddate" : data[4].strftime("%Y-%m-%d"),

            # pack_trans
            "trans" : data[5],

            # pack_tourlist
            "tourlist" : data[6],

            # pack_stay
            "stay" : data[7],

            "image" : data[8]
        }
        result.append(temp_dict)

    """
    -*- 2024-06-28 16:35, LCY -*-

    result 구조 : [dict, dict, dict, ...]

    id : int
    name : string
    price : int
    startdate : string
    enddate : string
    trans : string
    tourlist : string
    stay : string

    result = [
        {
            "id"        :  1,
            "name"      :  "한라산 둘레길",
            "price"     :  100000000,
            "startdate" :  "2024-06-28T16:06:18",
            "enddate"   :  "2024-06-28T16:06:22",
            "trans"     :  "고속버스",
            "tourlist"  :  "서울역, 김포공항, 제주공항, 한라산",
            "stay"      :  "3박 4일"
        }
    ]
    """
    return result

@router.get("/select/detail")
async def packageDetailSelect(pack_id: int) :
    try :
        conn = connect()
        curs = conn.cursor()

        sql = "select * from package where pack_id = %s"
        
        curs.execute(sql, pack_id)
        rows = curs.fetchall()

        curs.close()

        print(rows)

        """
        [
            [   2, 
                "데이트&나이트 투어",
                250000, 
                "2024-07-01",
                "2024-07-16",
                "비행기, 고속버스",
                "제주공항, 감귤농장",
                "제주호텔",
                "w9.jpg"
            ]
        ]
        """

        return make_dict(rows[0])
    except :
        return "error"

@router.get("/image")
async def packageImage(img_name: str) :
    from fastapi import File
    from fastapi.responses import FileResponse

    return FileResponse(f'./images/{img_name}')


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