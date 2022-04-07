//
//  NetworkService.swift
//  VK
//
//  Created by Konstantin Zaytcev on 04.04.2022.
//

import Foundation
import Alamofire

final class NetworkService
{
    let host = "https://api.vk.com/method/"
    let v = "5.131"
    
    // Получение списка друзей
    func methodFriendsGet(
        userId: Int,
        completion: @escaping (Result<[UserModel], Error>) -> Void)
    {
        let method = "friends.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": SomeSingleton.instance.token,
            "fields": "photo_100,photo_200",
            "v": v
        ]
        
        AF.request(
            host + method,
            method: .get,
            parameters: parameters)
        .response { response in
            
            do {
                
                let vkResponse = try JSONDecoder().decode(
                    VKResponse<UserModel>.self,
                    from: response.data!
                )
                
                completion(.success(vkResponse.response.items))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Получение групп текущего пользователя
    func methodGroupsGet(
        userId: Int,
        completion: @escaping (Result<[GroupModel], Error>) -> Void)
    {
        let method = "groups.get"
        
        let parameters: Parameters = [
            "user_id": userId,
            "access_token": SomeSingleton.instance.token,
            "extended": "1",
            "fields": "photo_100",
            "v": v
        ]
        
        AF.request(
            host + method,
            method: .get,
            parameters: parameters)
        .response { response in
            
            do {
                
                let vkResponse = try JSONDecoder().decode(
                    VKResponse<GroupModel>.self,
                    from: response.data!
                )
                
                completion(.success(vkResponse.response.items))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Получение групп по поисковому запросу
    func methodGroupsSearch(
        query: String,
        completion: @escaping (Result<[GroupModel], Error>) -> Void)
    {
        let method = "groups.search"
        
        let parameters: Parameters = [
            "q": query,
            "access_token": SomeSingleton.instance.token,
            "v": v
        ]
        
        AF.request(
            host + method,
            method: .get,
            parameters: parameters)
        .response { response in
            
            do {
                
                let vkResponse = try JSONDecoder().decode(
                    VKResponse<GroupModel>.self,
                    from: response.data!
                )
                
                completion(.success(vkResponse.response.items))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Получение фотографий человека
    func methodPhotosGet(
        userId: Int,
        completion: @escaping (Result<[PhotoModel], Error>) -> Void)
    {
        let method = "photos.get"
        
        let parameters: Parameters = [
            "owner_id": userId,
            "access_token": SomeSingleton.instance.token,
            "album_id": "wall",
            "extended": "1",
            "rev": "1",
            "v": v
        ]
        
        AF.request(
            host + method,
            method: .get,
            parameters: parameters)
        .response { response in
            
            do {
                
                let vkResponse = try JSONDecoder().decode(
                    VKResponse<PhotoModel>.self,
                    from: response.data!
                )
                
                completion(.success(vkResponse.response.items))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}
