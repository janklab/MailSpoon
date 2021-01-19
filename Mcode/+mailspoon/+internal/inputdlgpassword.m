function out = inputdlgpassword(prompt, dlgtitle)
% A version of inputdlg that masks the input so you can prompt for passwords
arguments
  prompt (1,1) string = "Enter password:"
  dlgtitle (1,1) string = "Enter password"
end

import javax.swing.JPanel
import javax.swing.JLabel
import javax.swing.JPasswordField
import javax.swing.JOptionPane

panel = JPanel;
label = JLabel(prompt);
passwordField = JPasswordField(40);
panel.add(label);
panel.add(passwordField);
buttons = mailspoon.internal.util.strings2java(["OK", "Cancel"]);
choice = JOptionPane.showOptionDialog([], panel, dlgtitle, JOptionPane.NO_OPTION, ...
  JOptionPane.PLAIN_MESSAGE, [], buttons, buttons(2));
if choice == 0
  % Pressed OK
  out = string(passwordField.getPassword');
else
  % Cancelled
  out = [];
end
end
