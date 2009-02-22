require 'tmpdir'

desc "Install releasenotes app non-gem dependencies"
task :depstest => ["test:rmagick", "test:ldap"]

namespace :test do
  desc "Install Ruby/LDAP"
  file "/Library/Ruby/Site/1.8/ldap/" do
    `curl http://voxel.dl.sourceforge.net/sourceforge/ruby-ldap/ruby-ldap-0.9.7.tar.gz -o #{DOWNLOAD_DIR}/ruby-ldap.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/ruby-ldap.tar.gz")
    `tar -xzf #{DOWNLOAD_DIR}/ruby-ldap.tar.gz -C #{DOWNLOAD_DIR}`
    `cd #{DOWNLOAD_DIR}/ruby-ldap*/ && ./#{CONFIGURE} && make && sudo make install`
    puts "Installed Ruby/LDAP"
  end
  
  desc "Install rmagick and all of its dependencies"
  task :rmagick => "rmagick:gem"

  namespace :rmagick do
    DOWNLOAD_DIR = Dir.tmpdir + "/rake"
    CONFIGURE="configure --prefix=/usr/local"

    desc "Install rmagick gem"
    task :gem => "/usr/local/bin/Magick-config" do
      unless `gem list -i rmagick`.chomp == "true"
        puts "Installing the rmagick gem"
        `sudo gem install rmagick`
        puts "Installed rmagick gem"
      else
        puts "rmagick gem already installed"
      end
    end

    desc "Install ImageMagick"
    file "/usr/local/bin/Magick-config" => ["/usr/local/share/ghostscript", "/usr/local/share/ghostscript/fonts/", "/usr/local/lib/libfontconfig.a", "/usr/local/include/freetype2", "/usr/local/lib/libjpeg.a", "/usr/local/lib/liblcms.a", "/usr/local/lib/libtiff.a", "/usr/local/lib/libpng.a", "/usr/local/lib/libwmf.a", DOWNLOAD_DIR] do
      puts "Downloading and installing ImageMagick"
      # download and install ImageMagick from source
      `curl ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz -o #{DOWNLOAD_DIR}/ImageMagick.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/ImageMagick.tar.gz")
#      `curl ftp://ftp.imagemagick.org/pub/ImageMagick/ImageMagick.tar.gz -o #{DOWNLOAD_DIR}/ImageMagick.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/ImageMagick.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/ImageMagick.tar.gz -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/ImageMagick*/ && export CPPFLAGS=-I/usr/local/include && export LDFLAGS=-L/usr/local/lib && ./#{CONFIGURE} --disable-static --with-modules --without-perl --without-magick-plus-plus --with-quantum-depth=8 --with-gs-font-dir=/usr/local/share/ghostscript/fonts && make && sudo make install`
    end

    desc "Install ghostscript and fonts"
    file "/usr/local/share/ghostscript" => ["/usr/local/lib/libpng.a", "/usr/local/lib/libjpeg.a", DOWNLOAD_DIR] do
      unless File.exists?()
        puts "Downloading and installing ghostscript"
        `curl http://ghostscript.com/releases/ghostscript-8.64.tar.bz2 -o #{DOWNLOAD_DIR}/ghostscript.tar.bz2` unless File.exists?("#{DOWNLOAD_DIR}/ghostscript.tar.bz2")
        `tar -xjf #{DOWNLOAD_DIR}/ghostscript.tar.bz2 -C #{DOWNLOAD_DIR}`
        `cd #{DOWNLOAD_DIR}/ghostscript*/ && ./#{CONFIGURE} && make && sudo make install`
        puts "Finished installing ghostscript"
      else
        puts "Ghostscript already installed"
      end
    end

    desc "Install ghostscript fonts"
    file "/usr/local/share/ghostscript/fonts/" => [DOWNLOAD_DIR, "/usr/local/share/ghostscript"] do
      puts "Downloading and installing ghostscript fonts"
      if File.exists?("#{DOWNLOAD_DIR}/fonts/")
        `cd #{DOWNLOAD_DIR}/fonts/ && svn cleanup && svn up -q`
      else
        `svn co -q http://svn.ghostscript.com/ghostscript/tags/ghostscript-fonts-std-8.11/ #{DOWNLOAD_DIR}/fonts`
      end
      `sudo mkdir -p /usr/local/share/ghostscript/fonts/`
      `cd #{DOWNLOAD_DIR}/fonts && ls |grep -v COPYING|grep -v ChangeLog|grep -v README|grep -v TODO|xargs -IFONT sudo cp FONT /usr/local/share/ghostscript/fonts/`
    end

    desc "Install libWMF (for SVG support)"
    file "/usr/local/lib/libwmf.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libWMF"
      `curl http://voxel.dl.sourceforge.net/sourceforge/wvware/libwmf-0.2.8.4.tar.gz -o #{DOWNLOAD_DIR}/libwmf.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/libwmf.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/libwmf.tar.gz -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/libwmf*/ && ./#{CONFIGURE} && make clean && make && sudo make install`
    end

    desc "Install FreeType"
    file "/usr/local/include/freetype2" => DOWNLOAD_DIR do
      puts "Downloading and installing FreeType"
      `curl http://download.savannah.gnu.org/releases-noredirect/freetype/freetype-2.3.8.tar.bz2 -o #{DOWNLOAD_DIR}/freetype.tar.bz2` unless File.exists?("#{DOWNLOAD_DIR}/freetype.tar.bz2")
      `tar -xjf #{DOWNLOAD_DIR}/freetype.tar.bz2 -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/freetype*/ && ./#{CONFIGURE} && make && sudo make install`
    end

    desc "Install PNG Support library"
    file "/usr/local/lib/libpng.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libPNG"
      `curl ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.34.tar.bz2 -o #{DOWNLOAD_DIR}/libpng.tar.bz2` unless File.exists?("#{DOWNLOAD_DIR}/libpng.tar.bz2")
      `tar -xjf #{DOWNLOAD_DIR}/libpng.tar.bz2 -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/libpng*/ && ./#{CONFIGURE} && make && sudo make install`
    end

    desc "Install JPEG support library"
    file "/usr/local/lib/libjpeg.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libJPEG"
      `curl http://www.ijg.org/files/jpegsrc.v6b.tar.gz -o #{DOWNLOAD_DIR}/jpegsrc.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/jpegsrc.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/jpegsrc.tar.gz -C #{DOWNLOAD_DIR}`
      glibtool = `which glibtool`.chomp
      target = `sw_vers -productVersion`.chomp.split(".")[0..1].join(".")
      cwd = `cd #{DOWNLOAD_DIR}/jpeg*/ && pwd`.chomp
      #puts cwd
      `cd #{cwd}/ ; ln -s #{glibtool} ./libtool && export MACOSX_DEPLOYMENT_TARGET=#{target} && ./#{CONFIGURE} --enable-shared && make && sudo make install`
    end

    desc "Install TIFF support library"
    file "/usr/local/lib/libtiff.a" => DOWNLOAD_DIR do
      puts "Downloading and installing libTIFF"
      `curl http://dl.maptools.org/dl/libtiff/tiff-3.8.2.tar.gz -o #{DOWNLOAD_DIR}/tiff.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/tiff.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/tiff.tar.gz -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/tiff*/ && ./#{CONFIGURE} && make && sudo make install`
    end

    desc "Install Little Color Management System"
    file "/usr/local/lib/liblcms.a" => ["/usr/local/lib/libtiff.a", :jpeg, DOWNLOAD_DIR] do
      puts "Downloading and installing little CMS"
      `curl http://www.littlecms.com/lcms-1.17.tar.gz -o #{DOWNLOAD_DIR}/lcms.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/lcms.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/lcms.tar.gz -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/lcms*/ && ./#{CONFIGURE} && make && sudo make install`
    end

    desc "Install fontconfig"
    file "/usr/local/lib/libfontconfig.a" => [DOWNLOAD_DIR, :freetype] do
	    puts "Downloading and installing fontconfig"
      `curl http://fontconfig.org/release/fontconfig-2.6.0.tar.gz -o #{DOWNLOAD_DIR}/fontconfig.tar.gz` unless File.exists?("#{DOWNLOAD_DIR}/fontconfig.tar.gz")
      `tar -xzf #{DOWNLOAD_DIR}/fontconfig.tar.gz -C #{DOWNLOAD_DIR}`
      `cd #{DOWNLOAD_DIR}/fontconfig*/ && ./#{CONFIGURE} && make && sudo make install`
    end
  end
end

private
file DOWNLOAD_DIR do
  Dir.mkdir DOWNLOAD_DIR
end
