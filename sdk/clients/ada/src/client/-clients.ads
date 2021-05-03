--  FastAPI
--  No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
--
--  The version of the OpenAPI document: 0.1.0
--  
--
--  NOTE: This package is auto generated by OpenAPI-Generator 4.0.0.
--  https://openapi-generator.tech
--  Do not edit the class manually.

with .Models;
with Swagger.Clients;
package .Clients is

   type Client_Type is new Swagger.Clients.Client_Type with null record;

   --  Read Users
   procedure Read_Users_Image_Image_Uncolorization_Users_Get
      (Client : in out Client_Type;
       Result : out Swagger.Object);

   --  Root
   procedure Root_Get
      (Client : in out Client_Type;
       Result : out Swagger.Object);

   --  Read User
   procedure Read_User_Image_Image_Uncolorization_Users_Username_Post
      (Client : in out Client_Type;
       Username : in Swagger.UString;
       Result : out Swagger.Object);

   --  Read User Me
   procedure Read_User_Me_Image_Image_Uncolorization_Users_Me_Get
      (Client : in out Client_Type;
       Result : out Swagger.Object);

end .Clients;
