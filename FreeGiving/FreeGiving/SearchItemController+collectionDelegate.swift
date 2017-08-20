//
//  File.swift
//  FreeGiving
//
//  Created by Brady Huang on 2017/8/10.
//  Copyright © 2017年 AppWorks. All rights reserved.
//

import UIKit
import Firebase

private let searchCell = "Cell"

extension SearchItemController: UICollectionViewDelegateFlowLayout {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let user = User()

        user.id = filteredProducts[indexPath.row].user

        let ref = Database.database().reference().child("users").child(user.id!)

        ref.observe(.value, with: { (snapshot) in

            guard let dictionary = snapshot.value as? [String: AnyObject]
                else {
                    return
            }
            user.setValuesForKeys(dictionary)

            self.showChatControllerForUser(user: user)

        }, withCancel: nil)

    }

    func showChatControllerForUser(user: User) {

        let vc = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())

        vc.user = user

        let nv = UINavigationController(rootViewController: vc)

        present(nv, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: screenSize.width/2, height: screenSize.height/2)

    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // swiftlint:disable force_cast
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: searchCell, for: indexPath) as! PostCollectionViewCell
        // swiftlint:enable force_cast

        cell.backgroundColor = UIColor.black

        cell.productPost = filteredProducts[indexPath.row]

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return filteredProducts.count

    }

    func setupCVLayout() {

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        layout.minimumInteritemSpacing = 0

        layout.minimumLineSpacing = 0

        collectionView!.collectionViewLayout = layout

    }
}
