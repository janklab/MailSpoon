package net.janklab.mailspoon.internal;

import javax.mail.internet.MimeMultipart;

/**
 * This class just exists to publicly expose the MIME Multipart Container, so
 * we can inspect and debug it in Matlab.
 */
public class DebuggableHtmlEmail extends org.apache.commons.mail.HtmlEmail {

    public MimeMultipart reallyGetContainer() {
        return getContainer();
    }

    public void reallyInitialize() {
        init();
    }

    public boolean reallyIsInitialized() {
        return isInitialized();
    }
}
