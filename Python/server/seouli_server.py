from fastapi import FastAPI
import pymysql
from seouli_package import router as package_router
from seouli_purchase import router as purchase_router

app = FastAPI()

host_ip = '192.168.50.83'

def connect() :
    # MySQL Connection
    return pymysql.connect(
        host=host_ip,
        user='root',
        password='qwer1234',
        db='seouli',
        charset='utf8'
    )

# ------

# package table router
app.include_router(package_router, prefix="/package", tags=['package'])
app.include_router(purchase_router, prefix="/purchase", tags=['purchase'])


if __name__ == "__main__" :
    import uvicorn
    uvicorn.run(app, host=host_ip, port=8000)