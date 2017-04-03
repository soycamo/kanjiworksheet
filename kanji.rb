require 'open-uri'
require 'json'
require 'erb'

class KanjiWorksheet
  # API Key should actually be a constant...
  attr_accessor :api_key, :level, :template

  def initialize(api_key, level)
    @level = level
    @api_key = api_key
  end

  def template
    %{
<!DOCTYPE HTML>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Kanji level <%= @level %></title>
  <style type="text/css">
  td {
    border: 1px solid #dedede;
    border-spacing: 0.5rem;
  }
  p.one{
    border-right: 1px dashed #dedede;
    border-bottom: 1px dashed #dedede;
    height: 55px;
    width: 55px;
    margin: 0 55px 0 0;
  }
  p.two {
    border-left: 1px dashed #dedede;
    border-top: 1px dashed #dedede;
    margin: 0 0 0 55px;
    height: 55px;
    width: 55px;
  }
  p.one.darker, p.two.darker {
  border-color: #000;
  }
  .faded {
    opacity: 0.3;
    position: relative;
    top: 0px;
    display:inline-block; }
  @media print {
    tr { break-inside: avoid;
   -webkit-region-break-inside: avoid;
    }
  }
  </style>
</head>
<body>
  <table>
  <% for @k in @kanji_ary %>
    <tr>
      <td><img src="./kanji/0<%= @k %>.svg"></td>
      <td><span class="faded" style="background:url('./kanji/0<%= @k %>.svg');"><p class="one darker">&nbsp;</p><p class="two darker">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
      <td><p class="one">&nbsp;</p><p class="two">&nbsp;</p></td>
    </tr>
  <% end %>
  </table>
</body>
</html>
    }
  end

  def print
    @kanji_ary = get_kanji
    ERB.new(template).result(binding)
  end

  def get_kanji
    open("https://www.wanikani.com/api/user/05ae64af5a6575e0cd7ca4683c597d01/kanji/1") do |f|
      json = JSON.parse f.read
      kanji = json["requested_information"].collect do |k|
        k["character"].codepoints.first.to_s(16)
      end
      # seems wrong since closures...
      # Do you yield here?
      return kanji
    end
  end

end

File.write('test.html', KanjiWorksheet.new(ENV['WANIKANI_API'], 1).print)
