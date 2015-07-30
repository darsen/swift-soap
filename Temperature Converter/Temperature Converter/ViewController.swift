import UIKit

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData.alloc()
    var currentElementName:NSString = ""
    
    
    
    @IBOutlet var txtCelsius : UITextField!
    @IBOutlet var txtFahrenheit : UITextField!
    
    
    @IBAction func actionConvert(sender : AnyObject) {
        var celcius = txtCelsius.text
        
        var soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/webservices/'><Celsius>\(celcius)</Celsius></CelsiusToFahrenheit></soap:Body></soap:Envelope>"
        
        
        var urlString = "http://www.w3schools.com/webservices/tempconvert.asmx"
        
        var url = NSURL(string: urlString)
        
        var rq = NSMutableURLRequest(URL: url!)
        
        var msgLength = String(count(soapMessage))
        
        rq.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        rq.addValue(msgLength, forHTTPHeaderField: "Content-Length")
        rq.HTTPMethod = "POST"
        rq.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        var connection = NSURLConnection(request: rq, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }

    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
        
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        currentElementName = elementName
        
    }

    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        if currentElementName == "CelsiusToFahrenheitResult" {
            txtFahrenheit.text = string
        }
    }

}

