import Foundation


// Array의 잘못된 인덱스 접근 시 app crash가 발생한다.
// subscript를 통해 안전하게 접근하는 extention
extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
