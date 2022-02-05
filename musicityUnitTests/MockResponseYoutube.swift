//
//  MockResponseYoutube.swift
//  musicityUnitTests
//
//  Created by Brian Friess on 04/02/2022.
//

import Foundation



// MARK:- Mock to help download
protocol MockSession {
    func downloadTask(with url: URL, completionHandler: @escaping (URL?, URLResponse?, Error?) -> Void) -> URLSessionDownloadTask
}


