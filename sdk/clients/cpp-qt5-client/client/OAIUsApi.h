/**
 * FastAPI
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 0.1.0
 * 
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

#ifndef OAI_OAIUsApi_H
#define OAI_OAIUsApi_H

#include "OAIHttpRequest.h"

#include "OAIHTTPValidationError.h"
#include "OAIObject.h"
#include <QString>

#include <QObject>

namespace OpenAPI {

class OAIUsApi: public QObject {
    Q_OBJECT

public:
    OAIUsApi();
    OAIUsApi(QString host, QString basePath);
    ~OAIUsApi();

    QString host;
    QString basePath;
    QMap<QString, QString> defaultHeaders;

    void readUserImageImageUncolorizationUsersUsernamePost(const QString& username);
    
private:
    void readUserImageImageUncolorizationUsersUsernamePostCallback (OAIHttpRequestWorker * worker);
    
signals:
    void readUserImageImageUncolorizationUsersUsernamePostSignal(OAIObject summary);
    
    void readUserImageImageUncolorizationUsersUsernamePostSignalFull(OAIHttpRequestWorker* worker, OAIObject summary);
    
    void readUserImageImageUncolorizationUsersUsernamePostSignalE(OAIObject summary, QNetworkReply::NetworkError error_type, QString& error_str);
    
    void readUserImageImageUncolorizationUsersUsernamePostSignalEFull(OAIHttpRequestWorker* worker, QNetworkReply::NetworkError error_type, QString& error_str);
    
};

}
#endif
