use std::io;
use std::fs::{self, DirEntry};
use std::path::Path;
use std::process::Command;

fn tangle_org(parent: &Path, file: &Path) -> io::Result<()> {
    let name = file.file_name().unwrap().to_str().unwrap();
    let parent = parent.file_name().unwrap().to_str().unwrap();
    if name == "Cargo.org" {
        println!("Tangle: Ignoring file {}", name);
        return Ok(());
    } else {
        println!("Tangle: Tangling file {}", name);
        match file.extension() {
            Some(xt) => {
                let ext = file.extension().unwrap().to_str().unwrap();
                if ext == "org" {
                    let command = format!("--eval \"(progn \
                                           (require 'org)\
                                           (require 'ob)\
                                           (require 'ob-tangle)\
                                           (find-file \
                                           (expand-file-name \\\"{}\\\" \\\"\\\"))\
                                           (org-babel-tangle)\
                                           (kill-buffer))\"", name);
                    let result = Command::new("emacs")
                        .args(&["-Q", "--batch"])
                        .arg(&command)
                        .output()
                        .expect(&format!("Failed command {}", name));
                    println!("status: {}", result.status);
                    println!("stdout: {}", String::from_utf8_lossy(&result.stdout));
                    println!("stderr: {}", String::from_utf8_lossy(&result.stderr));

                }
            } 
            None => {}
        }
        return Ok(());
    }
}

fn walk_tree(parent: &Path, dir: &Path) -> io::Result<()> {
    let full_dir_buf = parent.join(dir);
    let full_dir = full_dir_buf.as_path();
    println!("cargo:Entering {}", full_dir.file_name().unwrap().to_str().unwrap());
    for entry in try!(fs::read_dir(full_dir)) {
        let entry = try!(entry);
        let path = entry.path();
        if path.is_dir() {
            try!(walk_tree(&parent, &path));

        } else {
            tangle_org(&full_dir, &path);
        }
    }
    Ok(())
}

fn main() {
    println!("Tangling org files");
    walk_tree(Path::new(""), Path::new("./org"));
}
