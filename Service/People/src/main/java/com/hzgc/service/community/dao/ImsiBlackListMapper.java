package com.hzgc.service.community.dao;

import com.hzgc.service.community.model.ImsiBlackList;
import org.apache.ibatis.annotations.CacheNamespace;

@CacheNamespace
public interface ImsiBlackListMapper {
    int deleteByPrimaryKey(Long id);

    int insert(ImsiBlackList record);

    int insertSelective(ImsiBlackList record);

    ImsiBlackList selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(ImsiBlackList record);

    int updateByPrimaryKey(ImsiBlackList record);
}