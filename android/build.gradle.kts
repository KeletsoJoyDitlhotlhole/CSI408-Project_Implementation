plugins {
    id("com.android.application") version "7.0.0" apply false
    id("org.jetbrains.kotlin.android") version "1.8.0" apply false // Updated Kotlin version
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Define the new build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    // Define new subproject build directory
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)

    // Ensure the 'app' module is evaluated first
    project.evaluationDependsOn(":app")
}

// Task to clean the build directories
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
