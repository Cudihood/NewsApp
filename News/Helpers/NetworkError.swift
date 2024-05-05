//
//  NetworkError.swift
//  News
//
//  Created by Даниил Циркунов on 04.05.2024.
//

import Foundation

/// Список ошибок, которые может вернуть NetworkManager помимо стандартных ошибок URLSession.
enum NetworkError: Error {
    /// Не удалось инициализировать URL из строкового значения.
    case invalidURL
    /// Запрос выполнен успешно, но не удалось преобразовать ответ сервера в ожидаемую структуру данных.
    case invalidData
    /// Получен неизвестный ответ от сервера.
    case invalidServerResponse(code: Int?)
    /// Отсутствует соединение с интернетом.
    case notConnectedToInternet
    /// Сервер временно недоступен.
    case serverUnavailable
    /// Получен неизвестный ответ от сервера.
    case invalidError(string: String?)
    /// Отсутствуют данные и ответ
    case notDataAndResponse
}
