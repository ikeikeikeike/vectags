
/*
  #: TODO Constructorで初期値書き換え
*/
/*case */class OptionParser {

  val PRODUCT: String = "createtags-scala"
  val VERSION: String = "0.1"
  val versionMessage: String = PRODUCT + " " + VERSION
  val helpMessage: String = """
  Usage: """ + PRODUCT + """ [OPTION...] [PATH]

  Options::

    -h                   --help                                show this help message and exit.
    -v                   --version                             output the version number.
    -a                   --all                                 all in virtualenv packages. ignore all options.
    -p PACKAGES          --packages=PACKAGES                   give packages name. default is a `haskell` package.
    -s STANDARDPACKAGES  --standard-packages=STANDARDPACKAGES  give packages name. for the standard library.
                         --no-sbt                              not include the sbt library.
                         --allow-testcode                      include the test code.
  """

  var path = ""
  var all = false
  var packages = ""
  var spackages = ""
  var sbt = true
  var allowTestcode = false

  def parse(args: List[String]): List[String] = {
    args match {

      case ("-a" | "--all") :: rest =>
        all = true
        parse(rest)

      case ("-p" | "--packages") :: packages :: rest =>
        this.packages = packages
        parse(rest)

      case ("-p" | "--packages") :: Nil =>
        println("Option (-p | --packages) requires an argument")
        sys.exit(1)

      case ("-s" | "--standard-packages") :: spackages :: rest =>
        this.spackages = spackages
        parse(rest)

      case ("-s" | "--standard-packages") :: Nil =>
        println("Option (-s | --standard-packages) requires an argument")
        sys.exit(1)

      case ("--no-sbt") :: rest =>
        sbt = false
        parse(rest)

      case ("--allow-testcode") :: rest =>
        allowTestcode = true
        parse(rest)

      case ("-h" | "--help") :: rest =>
        Console.println(helpMessage)
        sys.exit(0)

      case ("-v" | "--version" | "-varsion") :: rest =>
        Console.println(versionMessage)
        sys.exit(0)

      case _ =>
        path = args.mkString(" ")
        args

    }
  }

  override def toString = "OptionParser(" +
    "path: " + path +
    ", all: " + all +
    ", packages: " + packages +
    ", spackages: " + spackages +
    ", sbt: " + sbt +
    ", allowTestcode: " + allowTestcode +
    ")"
}


object OptionParser {
  def main(args: Array[String]) {

    val opts = new OptionParser
    opts.parse(args.toList)

    Console.println(opts)
  }
}


/* vim: set et fenc=utf-8 ft=scala ff=unix sts=0 sw=2 ts=2 : */
