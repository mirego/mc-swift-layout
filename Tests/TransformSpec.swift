//  Copyright (c) 2017 Luc Dion
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Quick
import Nimble
import PinLayout

class TransformSpec: QuickSpec {
    override func spec() {
        var viewController: UIViewController!
        
        var rootView: BasicView!
        var aView: BasicView!
        
        /*
          root
           |
            - aView
                |
                 - aViewChild
        */

        beforeEach {
            viewController = UIViewController()
            
            rootView = BasicView(text: "", color: .white)
            rootView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
            viewController.view.addSubview(rootView)
            
            aView = BasicView(text: "View A", color: UIColor.red.withAlphaComponent(0.5))
            aView.frame = CGRect(x: 140, y: 100, width: 200, height: 120)
            rootView.addSubview(aView)
        }
        
        describe("Using top, bottom, left, right, width and height") {
            it("Parent: No transform  Child: No transform") {
                rootView.transform = .identity
                aView.transform = .identity
                
                aView.pin.top(100).left(100).width(100).height(50)
                
                expect(aView.frame).to(equal(CGRect(x: 100, y: 100, width: 100.0, height: 50.0)))
            }
            
            it("Parent: No transform  Child: Scale transform") {
                rootView.transform = .identity
                aView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
                aView.pin.top(100).left(100).width(100).height(50)
                
                // The view should keep its transform
                expect(aView.frame).to(equal(CGRect(x: 50.0, y: 75.0, width: 200.0, height: 100.0)))
                
                // If we clear the transform, the view should retrieve the original frame.
                aView.transform = CGAffineTransform.identity
                expect(aView.frame).to(equal(CGRect(x: 100, y: 100, width: 100.0, height: 50.0)))
            }
            
            it("Parent: No transform  Child: No transform") {
                rootView.transform = .identity
                aView.transform = .identity
                
                aView.pin.top().bottom().left().right()
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: Scale transform  Child: No transform") {
                rootView.transform = CGAffineTransform(scaleX: 2, y: 2)
                aView.transform = .identity
                
                aView.pin.top().bottom().left().right()
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: Scale transform  Child: No transform") {
                rootView.transform = CGAffineTransform(scaleX: 2, y: 2)
                aView.transform = .identity
                
                aView.pin.top().left().width(100%).height(100%)
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
        }
            
        describe("Using topLeft and bottomRight") {
            it("Parent: No transform  Child: No transform") {
                rootView.transform = .identity
                aView.transform = .identity
                
                aView.pin.topLeft().bottomRight()
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: Scale transform  Child: No transform") {
                rootView.transform = CGAffineTransform(scaleX: 2, y: 2)
                aView.transform = .identity
                
                aView.pin.topLeft().bottomRight()
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
        }
        
        describe("Using anchors") {
            it("Parent: No transform  Child: No transform") {
                rootView.transform = .identity
                aView.transform = .identity
                
                aView.pin.topLeft(to: rootView.anchor.topLeft).bottomRight(to: rootView.anchor.bottomRight)
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: Scale transform  Child: No transform") {
                rootView.transform = CGAffineTransform(scaleX: 2, y: 2)
                aView.transform = .identity
                
                aView.pin.topLeft(to: rootView.anchor.topLeft).bottomRight(to: rootView.anchor.bottomRight)
                
                expect(aView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: No transform  Child: Scale transform") {
                rootView.transform = .identity
                aView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
                aView.pin.topLeft(to: rootView.anchor.topLeft).bottomRight(to: rootView.anchor.bottomRight)
                
                expect(aView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
            
            it("Parent: Scale transform  Child: Scale transform") {
                rootView.transform = CGAffineTransform(scaleX: 2, y: 2)
                aView.transform = CGAffineTransform(scaleX: 2, y: 2)
                
                aView.pin.topLeft(to: rootView.anchor.topLeft).bottomRight(to: rootView.anchor.bottomRight)
                
                expect(aView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                
                expect(rootView.frame).to(equal(CGRect(x: -200, y: -200, width: 800.0, height: 800.0)))
                expect(rootView.bounds).to(equal(CGRect(x: 0, y: 0, width: 400.0, height: 400.0)))
            }
        }
    }
}