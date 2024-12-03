from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from typing import List
import shutil
import os
from api.database import initialize_db, insert_cv, get_cvs_from_db

app = FastAPI()

class CV(BaseModel):
    id: str
    fileName: str
    downloadURL: str
    uploadedAt: str
    extractedInfo: dict

class MatchingResult(BaseModel):
    name: str
    email: str

cvs = []
matching_results = []

initialize_db()

@app.get("/api/cvs", response_model=List[CV])
async def get_cvs():
    return get_cvs_from_db()

@app.post("/api/cvs")
async def upload_cv(file: UploadFile = File(...)):
    file_location = f"files/{file.filename}"
    with open(file_location, "wb+") as file_object:
        shutil.copyfileobj(file.file, file_object)
    cv = CV(
        id=str(len(cvs) + 1),
        fileName=file.filename,
        downloadURL=file_location,
        uploadedAt="2023-01-01T00:00:00Z",
        extractedInfo={}
    )
    insert_cv(cv.fileName, cv.downloadURL, cv.uploadedAt, cv.extractedInfo)
    return {"info": "CV uploaded successfully"}

@app.get("/api/matching_results", response_model=List[MatchingResult])
async def get_matching_results():
    return matching_results

@app.post("/api/matching_results")
async def add_matching_result(result: MatchingResult):
    matching_results.append(result)
    return {"info": "Matching result added successfully"}
