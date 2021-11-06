/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

struct RandomImageResponse: Decodable {
  let urls: ImageType?
  let url: String?
  
  var activeURL: String {
    self.urls?.regular ?? self.url ?? ""
  }
}

// MARK: - Sample of complete JSON returned from API.

//https://random.dog/woof.json
// 20211106133420
// https://random.dog/woof.json
//
//{
//  "fileSizeBytes": 1445908,
//  "url": "https://random.dog/7b3154ef-18ea-42de-8c35-e8cd85ba9965.jpg"
//}

//// 20211106111706
//// https://api.unsplash.com/photos/random/?client_id=MkvxqMCKT5I9jCw1U325uEFET0c85d43vr7eJxsaDg4
//
//{
//  "id": "NFPw8HFsLg0",
//  "created_at": "2021-10-13T21:20:33-04:00",
//  "updated_at": "2021-11-06T04:30:57-04:00",
//  "promoted_at": "2021-10-14T17:40:01-04:00",
//  "width": 4160,
//  "height": 6240,
//  "color": "#c0d9d9",
//  "blur_hash": "LgK23HoLi^$%~qWAxFoJx]t6ofbH",
//  "description": null,
//  "alt_description": null,
//  "urls": {
//    "raw": "https://images.unsplash.com/photo-1634173987034-bab553cdf219?ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU&ixlib=rb-1.2.1",
//    "full": "https://images.unsplash.com/photo-1634173987034-bab553cdf219?crop=entropy&cs=srgb&fm=jpg&ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU&ixlib=rb-1.2.1&q=85",
//    "regular": "https://images.unsplash.com/photo-1634173987034-bab553cdf219?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU&ixlib=rb-1.2.1&q=80&w=1080",
//    "small": "https://images.unsplash.com/photo-1634173987034-bab553cdf219?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU&ixlib=rb-1.2.1&q=80&w=400",
//    "thumb": "https://images.unsplash.com/photo-1634173987034-bab553cdf219?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU&ixlib=rb-1.2.1&q=80&w=200"
//  },
//  "links": {
//    "self": "https://api.unsplash.com/photos/NFPw8HFsLg0",
//    "html": "https://unsplash.com/photos/NFPw8HFsLg0",
//    "download": "https://unsplash.com/photos/NFPw8HFsLg0/download?ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU",
//    "download_location": "https://api.unsplash.com/photos/NFPw8HFsLg0/download?ixid=MnwyNjkzODF8MHwxfHJhbmRvbXx8fHx8fHx8fDE2MzYyMTE4MjU"
//  },
//  "categories": [
//
//  ],
//  "likes": 48,
//  "liked_by_user": false,
//  "current_user_collections": [
//
//  ],
//  "sponsorship": null,
//  "topic_submissions": {
//    "street-photography": {
//      "status": "rejected"
//    }
//  },
//  "user": {
//    "id": "RSJOaCR98Os",
//    "updated_at": "2021-11-06T09:30:48-04:00",
//    "username": "duongtrungthinh",
//    "name": "Duong Thinh",
//    "first_name": "Duong",
//    "last_name": "Thinh",
//    "twitter_username": null,
//    "portfolio_url": "https://www.flickr.com/photos/trungthinhduong0303/",
//    "bio": null,
//    "location": "Osaka Japan",
//    "links": {
//      "self": "https://api.unsplash.com/users/duongtrungthinh",
//      "html": "https://unsplash.com/@duongtrungthinh",
//      "photos": "https://api.unsplash.com/users/duongtrungthinh/photos",
//      "likes": "https://api.unsplash.com/users/duongtrungthinh/likes",
//      "portfolio": "https://api.unsplash.com/users/duongtrungthinh/portfolio",
//      "following": "https://api.unsplash.com/users/duongtrungthinh/following",
//      "followers": "https://api.unsplash.com/users/duongtrungthinh/followers"
//    },
//    "profile_image": {
//      "small": "https://images.unsplash.com/profile-1623978803275-e8bfe25486d7image?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=32&w=32",
//      "medium": "https://images.unsplash.com/profile-1623978803275-e8bfe25486d7image?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=64&w=64",
//      "large": "https://images.unsplash.com/profile-1623978803275-e8bfe25486d7image?ixlib=rb-1.2.1&q=80&fm=jpg&crop=faces&cs=tinysrgb&fit=crop&h=128&w=128"
//    },
//    "instagram_username": "trungthinhduong",
//    "total_collections": 0,
//    "total_likes": 0,
//    "total_photos": 74,
//    "accepted_tos": true,
//    "for_hire": true,
//    "social": {
//      "instagram_username": "trungthinhduong",
//      "portfolio_url": "https://www.flickr.com/photos/trungthinhduong0303/",
//      "twitter_username": null,
//      "paypal_email": null
//    }
//  },
//  "exif": {
//    "make": "Canon",
//    "model": "Canon EOS 6D Mark II",
//    "name": "Canon, EOS 6D Mark II",
//    "exposure_time": "1/800",
//    "aperture": "11.0",
//    "focal_length": "100.0",
//    "iso": 1250
//  },
//  "location": {
//    "title": null,
//    "name": null,
//    "city": null,
//    "country": null,
//    "position": {
//      "latitude": null,
//      "longitude": null
//    }
//  },
//  "views": 182019,
//  "downloads": 966
//}
