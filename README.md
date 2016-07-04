OKSGutteredCodeView
===================
OKSGutteredCodeView is a swift library that provides a UIView subclass that has a textview with a gutter to the left that automatically counts line numbers.
This view can be easily initialized like any other view or used in a storyboard by dragging in a UIView and setting it's class to OKSGutteredTextView

This view provides several convenance methods for customizing the look of the view and a test app to see them in use

    // set the background color of the line number gutter
    func setGutterBackgroundColor(color: UIColor)
    
    //set the font for the text used in both the gutter and the textview
    func setfont(font: UIFont) 
    
    //programaticly get the font set on the textview
    func getFont() -> UIFont

    //set the text displayed in the textview programticly
    func setText(text: String) 

    //programaticly pull text in the textview
    func getText() -> String

    //add a toolbar to the keyboard
    func addTextViewAccessoryView(toolbar: UIToolbar)

    //insert text a the point the custer is currently at
    func insertTextAtCurser(text: String)

    //setattributed text in the textview
    func setAttributedText(text: NSAttributedString)

    //set font color
    func addFontColor(color: UIColor)

    //set background color for the textview
    func setTextViewBackgroundColor(color: UIColor)