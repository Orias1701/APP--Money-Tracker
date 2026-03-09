allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Chỉ đặt build dir tùy chỉnh cho subproject nằm trong project (vd :app).
// Không áp dụng cho Flutter plugins trong pub cache (khác ổ đĩa) để tránh lỗi
// "this and base files have different roots" trên Windows.
subprojects {
    val rootPath = rootProject.projectDir.absolutePath
    val projectPath = project.projectDir.absolutePath
    if (projectPath.startsWith(rootPath)) {
        val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
        project.layout.buildDirectory.value(newSubprojectBuildDir)
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
