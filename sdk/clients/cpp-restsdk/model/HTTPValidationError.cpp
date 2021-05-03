/**
 * FastAPI
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 0.1.0
 *
 * NOTE: This class is auto generated by OpenAPI-Generator 4.0.0.
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */



#include "HTTPValidationError.h"

namespace org {
namespace openapitools {
namespace client {
namespace model {




HTTPValidationError::HTTPValidationError()
{
    m_DetailIsSet = false;
}

HTTPValidationError::~HTTPValidationError()
{
}

void HTTPValidationError::validate()
{
    // TODO: implement validation
}

web::json::value HTTPValidationError::toJson() const
{
    web::json::value val = web::json::value::object();

    {
        std::vector<web::json::value> jsonArray;
        for( auto& item : m_Detail )
        {
            jsonArray.push_back(ModelBase::toJson(item));
        }
        if(jsonArray.size() > 0)
        {
            val[utility::conversions::to_string_t("detail")] = web::json::value::array(jsonArray);
        }
    }

    return val;
}

void HTTPValidationError::fromJson(const web::json::value& val)
{
    {
        m_Detail.clear();
        std::vector<web::json::value> jsonArray;
        if(val.has_field(utility::conversions::to_string_t("detail")))
        {
        for( auto& item : val.at(utility::conversions::to_string_t("detail")).as_array() )
        {
            if(item.is_null())
            {
                m_Detail.push_back( std::shared_ptr<ValidationError>(nullptr) );
            }
            else
            {
                std::shared_ptr<ValidationError> newItem(new ValidationError());
                newItem->fromJson(item);
                m_Detail.push_back( newItem );
            }
        }
        }
    }
}

void HTTPValidationError::toMultipart(std::shared_ptr<MultipartFormData> multipart, const utility::string_t& prefix) const
{
    utility::string_t namePrefix = prefix;
    if(namePrefix.size() > 0 && namePrefix.substr(namePrefix.size() - 1) != utility::conversions::to_string_t("."))
    {
        namePrefix += utility::conversions::to_string_t(".");
    }

    {
        std::vector<web::json::value> jsonArray;
        for( auto& item : m_Detail )
        {
            jsonArray.push_back(ModelBase::toJson(item));
        }
        
        if(jsonArray.size() > 0)
        {
            multipart->add(ModelBase::toHttpContent(namePrefix + utility::conversions::to_string_t("detail"), web::json::value::array(jsonArray), utility::conversions::to_string_t("application/json")));
        }
    }
}

void HTTPValidationError::fromMultiPart(std::shared_ptr<MultipartFormData> multipart, const utility::string_t& prefix)
{
    utility::string_t namePrefix = prefix;
    if(namePrefix.size() > 0 && namePrefix.substr(namePrefix.size() - 1) != utility::conversions::to_string_t("."))
    {
        namePrefix += utility::conversions::to_string_t(".");
    }

    {
        m_Detail.clear();
        if(multipart->hasContent(utility::conversions::to_string_t("detail")))
        {

        web::json::value jsonArray = web::json::value::parse(ModelBase::stringFromHttpContent(multipart->getContent(utility::conversions::to_string_t("detail"))));
        for( auto& item : jsonArray.as_array() )
        {
            if(item.is_null())
            {
                m_Detail.push_back( std::shared_ptr<ValidationError>(nullptr) );
            }
            else
            {
                std::shared_ptr<ValidationError> newItem(new ValidationError());
                newItem->fromJson(item);
                m_Detail.push_back( newItem );
            }
        }
        }
    }
}

std::vector<std::shared_ptr<ValidationError>>& HTTPValidationError::getDetail()
{
    return m_Detail;
}

void HTTPValidationError::setDetail(const std::vector<std::shared_ptr<ValidationError>>& value)
{
    m_Detail = value;
    m_DetailIsSet = true;
}

bool HTTPValidationError::detailIsSet() const
{
    return m_DetailIsSet;
}

void HTTPValidationError::unsetDetail()
{
    m_DetailIsSet = false;
}

}
}
}
}


