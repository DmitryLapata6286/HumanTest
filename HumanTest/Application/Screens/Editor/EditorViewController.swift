//
//  EditorViewController.swift
//  HumanTest
//

import UIKit
import SnapKit
import PhotosUI

final class EditorViewController: BaseViewController {
    
    private let contentView = UIView()
    private let containerView = UIView()
    
    private let leftBGView = UIView()
    private let rightBGView = UIView()
    private let topBGView = UIView()
    private let bottomBGView = UIView()
    
    private let imageView = UIImageView()
    private let placeholderLabel = BaseLabel(text: "Add Image", color: UIColor.label, font: UIFont.systemFont(ofSize: 20, weight: .semibold), textAlignment: .center)
    private let addButton = UIButton(type: .system)
    private let saveButton = UIButton(type: .system)
    private let segmentedControl = UISegmentedControl(items: ["Original", "B&W"])
    var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        applyOverlay()
    }
    
}

private extension EditorViewController {
    func configure() {
        view.backgroundColor = .clear
        configureContainerView()
        configureImageView()
        configureAddButton()
        configureSaveButton()
        configureImageGestures()
        configureSegmentedControl()
        addSubviews()
        makeConstraints()
        bind()
    }
    
    func configureContainerView() {
        contentView.clipsToBounds = true
        containerView.layer.borderColor = UIColor.yellow.cgColor
        containerView.layer.borderWidth = 2
        
        leftBGView.backgroundColor = .black.withAlphaComponent(0.4)
        rightBGView.backgroundColor = .black.withAlphaComponent(0.4)
        topBGView.backgroundColor = .black.withAlphaComponent(0.4)
        bottomBGView.backgroundColor = .black.withAlphaComponent(0.4)
    }
    
    func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
    }
    
    func configureImageGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        imageView.addGestureRecognizer(panGesture)
        imageView.addGestureRecognizer(pinchGesture)
        imageView.addGestureRecognizer(rotationGesture)
    }
    
    func configureAddButton() {
        addButton.setTitle("+ Add", for: .normal)
        addButton.setTitleColor(.purple, for: .normal)
    }
    
    func configureSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.purple, for: .normal)
    }
    
    func configureSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func addSubviews() {
        view.addSubviews(contentView,
                         addButton,
                         saveButton,
                         segmentedControl)
        contentView.addSubviews(containerView,
                                leftBGView,
                                rightBGView,
                                topBGView,
                                bottomBGView)
        containerView.addSubviews(placeholderLabel,
                                  imageView)
    }
    
    func makeConstraints() {
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(8)
            $0.leading.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(16)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalToSuperview().multipliedBy(0.6)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        leftBGView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(containerView.snp.leading)
            $0.bottom.equalTo(containerView.snp.bottom)
            
        }
        rightBGView.snp.makeConstraints {
            $0.top.equalTo(containerView.snp.top)
            $0.leading.equalTo(containerView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.bottom)
        }
        
        topBGView.snp.makeConstraints {
            $0.top.leading.centerX.equalToSuperview()
            $0.bottom.equalTo(containerView.snp.top)
        }
        
        bottomBGView.snp.makeConstraints {
            $0.bottom.leading.centerX.equalToSuperview()
            $0.top.equalTo(containerView.snp.bottom)
        }
        
        placeholderLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
                
        addButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalTo(20)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(addButton.snp.centerY)
        }
        
        saveButton.snp.makeConstraints {
            $0.centerY.equalTo(addButton.snp.centerY)
            $0.trailing.equalTo(-20)
        }
    }

    func bind() {
        addButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.addButtonTapped()
            }
            .store(in: &cancelables)
        
        saveButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.saveButtonTapped()
            }
            .store(in: &cancelables)
        
        segmentedControl.publisher(for: .valueChanged)
            .sink { [weak self] in
                guard let self else { return }
                segmentedControlChanged(segmentedControl)
            }
            .store(in: &cancelables)
    }
}

extension EditorViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let provider = results.first?.itemProvider,
                provider.canLoadObject(ofClass: UIImage.self) else { return }
        
        provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            guard let self, let image = image as? UIImage else { return }
            DispatchQueue.main.async {
                self.originalImage = image
                self.imageView.image = image
                self.placeholderLabel.isHidden = true
            }
        }
    }
}

// MARK: - Actions
private extension EditorViewController {
    // - Taps
    func addButtonTapped() {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func saveButtonTapped() {
        guard let image = imageView.image else { return }
        guard let croppedImage = cropImageToContainerBounds(image: image) else {
            showAlert(title: "Error", message: "error parsing image")
            return
        }
        UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func segmentedControlChanged(_ sender: UISegmentedControl) {
        guard let originalImage = originalImage else { return }
        switch sender.selectedSegmentIndex {
        case 0:
            imageView.image = originalImage
        case 1:
            if let filteredImage = applyBlackAndWhiteFilter(to: originalImage) {
                imageView.image = filteredImage
            }
        default:
            break
        }
    }
    // - objc gestures
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        let translation = gesture.translation(in: view)
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        imageView.transform = imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
    
    @objc func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let imageView = gesture.view else { return }
        imageView.transform = imageView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
            
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved", message: "Your image saved to gallery", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        let context = CIContext()
        guard let filter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        
        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
    
    func cropImageToContainerBounds(image: UIImage) -> UIImage? {
        containerView.layer.borderWidth = 0
        let renderer = UIGraphicsImageRenderer(bounds: containerView.bounds)
        let image = renderer.image { rendererContext in
          self.containerView.layer.render(in: rendererContext.cgContext)
        }
        containerView.layer.borderWidth = 2
        return image
    }
    
    func applyOverlay() {
        contentView.applyMask(forClearing: containerView.convert(containerView.bounds, to: contentView),
                                      overallColor: .black.withAlphaComponent(0.2))
    }
}
