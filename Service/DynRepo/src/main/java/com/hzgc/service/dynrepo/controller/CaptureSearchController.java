package com.hzgc.service.dynrepo.controller;

import com.hzgc.common.attribute.bean.Attribute;
import com.hzgc.common.attribute.service.AttributeService;
import com.hzgc.service.dynrepo.bean.*;
import com.hzgc.service.dynrepo.service.CaptureHistoryService;
import com.hzgc.service.dynrepo.service.CaptureSearchService;
import com.hzgc.service.util.response.ResponseResult;
import com.hzgc.service.util.rest.BigDataPath;
import io.swagger.annotations.*;
import io.swagger.models.HttpMethod;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.netflix.feign.FeignClient;
import org.springframework.web.bind.annotation.*;

import java.sql.SQLException;
import java.util.List;

@RestController
@FeignClient(name = "dynRepo")
@RequestMapping(value = BigDataPath.DYNREPO)
@Api(value = "/dynRepoSearch", tags = "以图搜图服务")
@SuppressWarnings("unused")
public class CaptureSearchController {

    @Autowired
    @SuppressWarnings("unused")
    private AttributeService attributeService;
    @Autowired
    @SuppressWarnings("unused")
    private CaptureHistoryService captureHistoryService;
    @Autowired
    @SuppressWarnings("unused")
    private CaptureSearchService captureSearchService;

    /**
     * 以图搜图
     *
     * @param searchOption 以图搜图入参
     * @return SearchResult
     */
    @ApiOperation(value = "以图搜图", response = SearchResult.class)
    @RequestMapping(value = BigDataPath.DYNREPO_SEARCH, method = RequestMethod.POST)
    @SuppressWarnings("unused")
    public ResponseResult<SearchResult> searchPicture(
            @RequestBody @ApiParam(value = "以图搜图入参") SearchOption searchOption) throws SQLException {
        SearchResult searchResult;
        if (searchOption != null) {
            searchResult = captureSearchService.searchPicture(searchOption);
        } else {
            searchResult = null;
        }
        return ResponseResult.init(searchResult);
    }

    /**
     * 获取搜索原图
     *
     * @param image_name 原图ID
     * @return 图片二进制
     */
    @ApiOperation(value = "获取原图", response = byte[].class, httpMethod = "GET")
    @ApiImplicitParam(name = "image_name", value = "原图ID", paramType = "query")
    public ResponseResult<byte[]> getSearchPicture(String image_name) {
        return ResponseResult.init(captureSearchService.getSearchPicture(image_name));
    }

    /**
     * 历史搜索记录查询
     *
     * @param searchResultOption 以图搜图入参
     * @return SearchResult
     */
    @ApiOperation(value = "历史搜索记录查询", response = SearchResult.class)
    @RequestMapping(value = BigDataPath.DYNREPO_SEARCHRESULT, method = RequestMethod.POST)
    @ApiImplicitParam(name = "searchResultOption", value = "以图搜图入参", paramType = "body")
    @SuppressWarnings("unused")
    public ResponseResult<SearchResult> getSearchResult(
            @RequestBody SearchResultOption searchResultOption) {
        SearchResult searchResult;
        if (searchResultOption != null) {
            searchResult = captureSearchService.getSearchResult(searchResultOption);
        } else {
            searchResult = null;
        }
        return ResponseResult.init(searchResult);
    }

    /**
     * 查询搜索记录
     *
     * @param start_time 历史记录起始时间
     * @param end_time   历史记录结束时间
     * @param sort       排序参数
     * @param start      起始位置
     * @param limit      返回条数
     * @return 返回查询结果
     */
    @ApiOperation(value = "查询搜索记录", response = SearchHisotry.class, responseContainer = "List")
    @ApiImplicitParams({
            @ApiImplicitParam(name = "start_time", value = "起始时间", paramType = "query"),
            @ApiImplicitParam(name = "end_time", value = "结束时间", paramType = "query"),
            @ApiImplicitParam(name = "sort", value = "排序参数", paramType = "query"),
            @ApiImplicitParam(name = "start", value = "起始位置", paramType = "query"),
            @ApiImplicitParam(name = "limit", value = "返回条数", paramType = "query")
    })
    @SuppressWarnings("unused")
    public ResponseResult<List<SearchHisotry>> getSearchHistory(
            String start_time,
            String end_time,
            String sort,
            int start,
            int limit) {
        return ResponseResult.init(captureSearchService.getSearchHistory(start_time, end_time, sort, start, limit));
    }

    /**
     * 人/车属性查询
     *
     * @return List<Attribute>
     */
    @ApiOperation(value = "属性特征查询", response = Attribute.class, responseContainer = "List")
    @RequestMapping(value = BigDataPath.DYNREPO_ATTRIBUTE, method = RequestMethod.GET)
    @SuppressWarnings("unused")
    public ResponseResult<List<Attribute>> getAttribute() {
        List<Attribute> attributeList;
        attributeList = attributeService.getAttribute();
        return ResponseResult.init(attributeList);
    }

    /**
     * 抓拍历史记录查询
     *
     * @param searchOption 以图搜图入参
     * @return List<SearchResult>
     */
    @ApiOperation(value = "抓拍历史记录查询", response = SearchResult.class, responseContainer = "List")
    @ApiImplicitParam(name = "searchOption", value = "pp", paramType = "body")
    @RequestMapping(value = BigDataPath.DYNREPO_HISTORY, method = RequestMethod.POST)
    @SuppressWarnings("unused")
    public ResponseResult<List<SingleCaptureResult>> getCaptureHistory(
            @RequestBody @ApiParam(value = "以图搜图入参") CaptureOption searchOption) {
        List<SingleCaptureResult> searchResultList;
        if (searchOption != null) {
            searchResultList = captureHistoryService.getCaptureHistory(searchOption);
        } else {
            searchResultList = null;
        }
        return ResponseResult.init(searchResultList);
    }
}