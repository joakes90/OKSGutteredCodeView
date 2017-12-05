OKSGutteredCodeView
===================
OKSGutteredCodeView is a swift library that provides a UIView subclass that has a textview
 with a gutter to the left that automatically counts line numbers.
This view can be easily initialized like any other view or used in a storyboard by dragging
in a UIView and setting it's class to OKSGutteredTextView

## Installing. 
The preferred method for setting up OKSGutteredCodeView in your project is via Cocoa Pods
    
    pod 'OKSGutteredCodeView', '~> 0.3'
    
For more information on using CocoaPods read the getting started guide at [cocoapods.org](https://cocoapods.org)

## Usage
This view provides several convenance methods for customizing the look of the view and a test app to see them in use

    // set the background color of the line number gutter
    func setGutterBackgroundColor(color: UIColor)

    //set font color
    func addFontColor(color: UIColor)

    //set background color for the textview
    func setTextViewBackgroundColor(color: UIColor)

    //set the font for the text used in both the gutter and the textview
    func setfont(font: UIFont) 

    //programaticly get the font set on the textview
    func getFont() -> UIFont

    //set the text displayed in the textview programticly
    func setText(text: String) 

    //set attributed text in the textview
    func setAttributedText(text: NSAttributedString)

    //append text to the end of the text view
    func appendText(text: String)

    //insert text a the point the custer is currently at
    func insertTextAtCurser(text: String)

    //programaticly pull text in the textview
    func getText() -> String

    //add a toolbar to the keyboard
    func addTextViewAccessoryView(toolbar: UIToolbar)

## Protocol
OKSGutteredCodeView also employs a protocol 'CodeViewDelegate' to pass information about 
events that it's performing to a delegate object. The following are CodeViewDelegate's methods.

    func textUpdated(text: String)
    //This is called when ever the text is updated. This can be useful for parsing user input to
    //implement your own syntax highlighting.

    func keyboardWillAppear(notification: Notification)
    //This is called whenever the keyboard is about to appear.

    func keyboardWillHide(_ notification: Notification)
    //Called when the keyboard is about to be dismissed.