package com.hzgc.service.community.dao;

import com.hzgc.service.community.model.RecognizeRecord;
import com.hzgc.service.community.param.*;

import java.util.List;

public interface RecognizeRecordMapper {
    int deleteByPrimaryKey(String id);

    int insert(RecognizeRecord record);

    int insertSelective(RecognizeRecord record);

    RecognizeRecord selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(RecognizeRecord record);

    int updateByPrimaryKey(RecognizeRecord record);

    List<RecognizeRecord> searchCapture1Month(String peopleid);

    List<RecognizeRecord> searchPeopleTrack1Month(String peopleid);

    RecognizeRecord searchCommunityOutPeopleLastCapture(String peopleid);

    List<RecognizeRecord> searchCommunityNewPeopleCaptureData(CaptureDetailsDTO param);

    List<ImportantPeopleRecognize> getImportantRecognizeRecord(ImportantRecognizeSearchParam param);

    String getSurlByPeopleId(String peopleid);
}