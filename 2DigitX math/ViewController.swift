//
//  TableViewController.swift
//  2DigitX math
//
//  Created by seya on 2016/03/16.
//  Copyright © 2016年 Double Bind, Inc. All rights reserved.
//

import Foundation

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var quizList : Array<String> = []
    var trickList : Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ナビゲーションバーの初期化：タイトルとボタン（左上、右上）
        self.navigationItem.title = "2DigitX Math"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "removeQuiz")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addQuiz")
        
        
        // TrickListを初期化
        trickList = ["AB x 11 = A_(A+B)_B\n(EX)54 x 11 = 5_(5+4)_4 = 594",
            "[if B+C=10] AB x AC = Ax(A+1)_BxC\n(EX)23 x 27 = 2x(2+1)_3x7 = 621",
            "AB x AB = (AB+B)xA0_BxB\n(EX)32 x 32 = (32+2)x30+2x2 = 1024",
            "AB x AC = (AB + C)xA0 + BxC\n(EX)28 x 27 = (28+7)x20+8x7 = 756" ];
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // セルの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }
    
    // セルの内容を変更
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        
        // Configure the cell.
        let quiz : String = quizList[indexPath.row] // row番目のQuiz
        
        cell.textLabel?.text = quiz.substringToIndex(quiz.endIndex.advancedBy(10))
        
        let trickNumer = quiz.substringWithRange(Range<String.Index>(start: quiz.startIndex.advancedBy(15), end: quiz.endIndex.advancedBy(1)))
        let index = Int(trickNumer)
        
        if (index != 9) {
            cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    // Cell が選択された場合
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        let selectedQuiz : String = quizList[indexPath.row] // Selected Quiz
        let cell = table.cellForRowAtIndexPath(indexPath) // Selected Cell
        cell!.textLabel?.text = selectedQuiz.substringToIndex(selectedQuiz.endIndex.advancedBy(14)) // Display Answer portion
    }
    
    func addQuiz() {
        var random1 = arc4random_uniform(10) // 乱数生成1
        var random2 = arc4random_uniform(10) // 乱数生成2
        
        if (random1 <= 9) { random1 = random1 + 9 }
        if (random2 <= 9) { random2 = random2 + 9 }
        
        // TrickNumberを決定
        let a2 = random1 / 10;
        let a1 = random1 - a2*10;
        
        let b2 = random2 / 10;
        let b1 = random2 - b2*10;
        
        var trickNumber = 0.0;
        if (random1 == 11 || random2 == 11) {
            trickNumber = 0;
        } else if ((a1 + b1) == 10 && a2 == b2) {
            trickNumber = 1;
        } else if (random1 == random2) {
            trickNumber = 2;
        } else if (random1 != 10 && random2 != 10 && a2 == b2 ){
            trickNumber = 3;
        } else {
            trickNumber = 9; // tricks not availble
        }
        
        // Quiz作成
        let quiz : String = String(format:"%08x", "%2d x %2d = %4d %d", random1, random2, random1*random2, trickNumber)
        quizList.append(quiz) // Quiz追加
        self.tableView.reloadData()
    }

    // ボタンが押された時にViewを切り換える Callback
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let selectedQuiz : String = quizList[indexPath.row] // Selected Quiz
        let trickNumer = selectedQuiz.substringWithRange(Range<String.Index>(start: selectedQuiz.startIndex.advancedBy(15), end: selectedQuiz.endIndex.advancedBy(1)))
        let index = Int(trickNumer)
        
        // UIAlertController を作成
        let alertController = UIAlertController(title: "Quick Math", message: trickList[index!] , preferredStyle: .Alert)
        
        // アラートを表示
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

