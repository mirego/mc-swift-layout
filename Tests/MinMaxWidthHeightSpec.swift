// Copyright (c) 2017, Mirego
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// - Redistributions of source code must retain the above copyright notice,
//   this list of conditions and the following disclaimer.
// - Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
// - Neither the name of the Mirego nor the names of its contributors may
//   be used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

import Quick
import Nimble
import PinLayout

class MinMaxWidthHeightSpec: QuickSpec {
    override func spec() {
        var viewController: UIViewController!
        var rootView: BasicView!
        var aView: BasicView!
        
        /*
          root
           |
            - aView
        */
        
        beforeSuite {
            setUnitTest(displayScale: 2)
        }

        beforeEach {
            unitTestLastWarning = nil
            
            viewController = UIViewController()
            
            rootView = BasicView(text: "", color: .white)
            rootView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
            viewController.view.addSubview(rootView)
            
            aView = BasicView(text: "View A", color: UIColor.red.withAlphaComponent(0.5))
            aView.frame = CGRect(x: 40, y: 100, width: 100, height: 60)
            aView.sizeThatFitsExpectedArea = 40 * 40
            rootView.addSubview(aView)
        }

        //
        // minWidth
        //
        describe("the result of the minWidth(...)") {
            it("should adjust the width of aView") {
                aView.pin.left().minWidth(50)
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 50.0, height: 60.0)))
            }

            it("should adjust the width of aView") {
                aView.pin.left().width(100).minWidth(150) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 150.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left().width(100).minWidth(50) // width > minWidth
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 100.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(100).right(100)//.minWidth(250) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 100.0, y: 100.0, width: 200.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(100).right(100).minWidth(250) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 75.0, y: 100.0, width: 250.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(100).right(100).marginLeft(100).minWidth(250) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 125.0, y: 100.0, width: 250.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(100).right(100).marginRight(100).minWidth(250) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 25.0, y: 100.0, width: 250.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.right(100).minWidth(300) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 300.0, height: 60.0)))
            }
            
            it("should adjust the width to 500 and keep the view in the center") {
                aView.pin.left().right().minWidth(500) // width < minWidth
                expect(aView.frame).to(equal(CGRect(x: -50.0, y: 100.0, width: 500.0, height: 60.0)))
            }
        }
        
        //
        // maxWidth
        //
        describe("the result of the maxWidth(...)") {
            
            it("should adjust the width of aView") {
                aView.pin.left().maxWidth(150)
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 150.0, height: 60.0)))
            }
        
            it("should adjust the width of aView") {
                aView.pin.left().maxWidth(150).marginLeft(50)
                expect(aView.frame).to(equal(CGRect(x: 50.0, y: 100.0, width: 150.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left().right().maxWidth(150)
                expect(aView.frame).to(equal(CGRect(x: 125.0, y: 100.0, width: 150.0, height: 60.0)))
            }

            it("should adjust the width of aView") {
                aView.pin.left().width(200).maxWidth(150)
                expect(aView.frame).to(equal(CGRect(x: 0.0, y: 100.0, width: 150.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.right().width(200).maxWidth(150)
                expect(aView.frame).to(equal(CGRect(x: 250.0, y: 100.0, width: 150.0, height: 60.0)))
            }

            it("should adjust the width of aView") {
                aView.pin.left(0).right(0).maxWidth(250).marginLeft(100)
                expect(aView.frame).to(equal(CGRect(x: 125.0, y: 100.0, width: 250.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(0).maxWidth(250).marginLeft(100)
                expect(aView.frame).to(equal(CGRect(x: 100.0, y: 100.0, width: 250.0, height: 60.0)))
            }

            it("should adjust the width of aView") {
                aView.pin.left(0).width(100%).maxWidth(250).marginLeft(100)
                expect(aView.frame).to(equal(CGRect(x: 100.0, y: 100.0, width: 250.0, height: 60.0)))
            }
            
            it("should adjust the width of aView") {
                aView.pin.left(0).right(0).marginRight(100).maxWidth(250)
                expect(aView.frame).to(equal(CGRect(x: 25.0, y: 100.0, width: 250.0, height: 60.0)))
            }
        }
    }
}