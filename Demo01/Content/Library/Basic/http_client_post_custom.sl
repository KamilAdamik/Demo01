#   Copyright 2024 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Executes an HTTP POST call towards a specified endpoint.
#!               By default the flow allows you to specify anything in the request body of the HTTP POST call
#!               (also known as a POST RAW call). You can also specify the Content-Type header for POST RAW request
#!               using the 'content-type' input.
#!
#! @input url: URL to which the call is made.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server.
#!                   Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)
#!                   Default: 'basic'
#! @input username: Optional - Username used for URL authentication; for NTLM authentication.
#!                  Format: 'domain\user'
#! @input password: Optional - Password used for URL authentication.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#! @input proxy_username: Optional - User name used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2 ,TLSv1.3.
#!                     Default: 'TLSv1.2'
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2' or 'TLSv1.3'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#!                         Valid values for TLSv1.3 : TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ''
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input keystore: Optional - The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Default value: ''
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: Optional - The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Default value: ''
#! @input request_character_set: Optional - Character encoding to be used for the HTTP request body; should not
#!                               be provided for method=GET, HEAD, TRACE.
#!                               Default: 'ISO-8859-1'
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing. When 0 value is
#!                           used, there is no limit on the amount of time allowed for the operation to finish executing.
#!                           Default: '300'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established. When 0 value is
#!                         used, there is no limit on the amount of time allowed for the connection to be established.
#!                         Default: '300'
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved. When 0 value is used, there is
#!                        no limit on the amount of time allowed for the data to be retrieved.
#!                        Default: '300'
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls.
#!                    Default: 'false'
#! @input connections_max_total: Optional - Maximum limit of connections in total.
#!                               Default: '20'
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF).
#!                 Header name - value pair will be separated by ":"
#!                 Format: According to HTTP standard for headers (RFC 2616)
#!                 Example: 'Accept:text/plain'
#! @input query_params: Optional - List containing query parameters to append to the URL.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input body: Optional - String to include in body for HTTP POST operation.
#! @input content_type: Optional - Content type that should be set in the request header, representing the
#!                      MIME-type of the data in the message body.
#!                      Default: 'text/plain'
#! @input method: HTTP method used.
#!                Default: 'POST'
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#! @input multipart_bodies: Optional - List of name=textValue pairs separated by "&"; will also take into account the
#!                          <content_type> and 'charset' inputs.
#! @input multipart_bodies_content_type: Optional - Each entity from the multipart entity has a content-type header; only
#!                                       specify once for all the parts. It is the only way to change the characterSet of
#!                                       the encoding.
#!                                       Default: 'text/plain; charset=ISO-8859-1'
#! @input multipart_files: Optional - List of name=filePath pairs.
#! @input multipart_files_content_type: Optional - Each entity from the multipart entity has a content-type header; only
#!                                      specify once for all parts.
#!                                      Examples: 'image/png', 'text/plain'
#!                                      Default: 'application/octet-stream'
#!
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: Return_result if status_code is not contained in interval between '200' and '299'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#!!#
########################################################################################################################

namespace: Basic
imports:
  http: io.cloudslang.base.http
flow:
  name: http_client_post_custom
  inputs:
    - url
    - auth_type:
        required: false
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - keystore:
        default: "${get_sp('io.cloudslang.base.http.keystore')}"
        required: false
    - keystore_password:
        default: "${get_sp('io.cloudslang.base.http.keystore_password')}"
        required: false
        sensitive: true
    - request_character_set:
        required: false
    - execution_timeout:
        default: '300'
        required: false
    - connect_timeout:
        default: '300'
        required: false
    - socket_timeout:
        default: '300'
        required: false
    - keep_alive:
        default: 'false'
        required: false
    - connections_max_per_route:
        default: '2'
        required: false
    - connections_max_total:
        default: '20'
        required: false
    - headers:
        required: false
    - query_params:
        required: false
    - body:
        required: false
    - content_type:
        default: text/plain
        required: false
    - method:
        default: POST
        private: true
    - worker_group:
        required: false
    - multipart_bodies:
        required: false
    - multipart_bodies_content_type:
        required: false
    - multipart_files:
        required: false
    - multipart_files_content_type:
        required: false
  workflow:
    - http_client_action_post:
        worker_group: "${get('worker_group', 'RAS_Operator_Path')}"
        do:
          http.http_client_action:
            - url
            - auth_type
            - username
            - password
            - tls_version
            - allowed_cyphers
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_all_roots
            - x_509_hostname_verifier
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - execution_timeout
            - connect_timeout
            - socket_timeout
            - keep_alive
            - connections_max_per_route
            - connections_max_total
            - request_character_set
            - headers
            - query_params
            - body
            - content_type
            - multipart_bodies: '${multipart_bodies}'
            - multipart_bodies_content_type: '${multipart_bodies_content_type}'
            - multipart_files: '${multipart_files}'
            - multipart_files_content_type: '${multipart_files_content_type}'
            - method
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - response_headers
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_action_post:
        x: 100
        'y': 150
        navigate:
          3dafe50f-2802-137f-c704-dc4096197074:
            targetId: eb40d01c-e70c-90da-8b4f-c6a91a00e494
            port: SUCCESS
    results:
      SUCCESS:
        eb40d01c-e70c-90da-8b4f-c6a91a00e494:
          x: 400
          'y': 150
