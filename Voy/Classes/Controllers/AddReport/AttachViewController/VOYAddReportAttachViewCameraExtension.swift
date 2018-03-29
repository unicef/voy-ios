//
//  VOYReportDetailCameraExtension.swift
//  Voy
//
//  Created by Daniel Amaral on 19/02/18.
//  Copyright © 2018 Ilhasoft. All rights reserved.
//

import UIKit

extension VOYAddReportAttachViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true) {

        }
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageRepresentation = UIImageJPEGRepresentation(image, 0.2),
            let fileName = VOYFileUtil.writeImageFile(imageRepresentation) {
            cameraData = VOYCameraData(
                image: image,
                thumbnail: nil,
                thumbnailFileName: nil,
                fileName: fileName,
                type: .image
            )
        } else if let mediaURL = info[UIImagePickerControllerMediaURL] as? URL {
            self.startAnimating()
            ISVideoUtil.compressVideo(inputURL: mediaURL, completion: { _, fileName in
                DispatchQueue.main.async {
                    self.stopAnimating()
                    guard let fileName = fileName,
                          let thumbnailImg = ISVideoUtil.generateThumbnail(mediaURL),
                          let thumbnailRepresentation = UIImageJPEGRepresentation(thumbnailImg, 0.2),
                          let thumbnailPath = VOYFileUtil.writeImageFile(thumbnailRepresentation) else { return }
                    self.cameraData = VOYCameraData(
                        image: nil,
                        thumbnail: thumbnailImg,
                        thumbnailFileName: thumbnailPath,
                        fileName: fileName,
                        type: .video
                    )
                }
            })
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
        }
    }
}
