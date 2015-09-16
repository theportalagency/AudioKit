//
//  AKDroplet.swift
//  AudioKit
//
//  Autogenerated by scripts by Aurelius Prochazka. Do not edit directly.
//  Copyright (c) 2015 Aurelius Prochazka. All rights reserved.
//

import Foundation

/** Semi-physical model of a water drop.

This is a physical model of the sound of dripping water. When triggered, it will produce a droplet of water.
*/
@objc class AKDroplet : AKParameter {

    // MARK: - Properties

    private var drip = UnsafeMutablePointer<sp_drip>.alloc(1)
    private var drip2 = UnsafeMutablePointer<sp_drip>.alloc(1)

    private var input = AKParameter()

    /** Period of time over which all sound is stopped. [Default Value: 0.09] */
    private var maximumDuration: Float = 0


    /** Number of units. The intensity of the dripping sound. [Default Value: 10] */
    var intensity: AKParameter = akp(10) {
        didSet {
            intensity.bind(&drip.memory.num_tubes, right:&drip2.memory.num_tubes)
            dependencies.append(intensity)
        }
    }

    /** The damping factor. Maximum value is 2.0. [Default Value: 0.2] */
    var dampingFactor: AKParameter = akp(0.2) {
        didSet {
            dampingFactor.bind(&drip.memory.damp, right:&drip2.memory.damp)
            dependencies.append(dampingFactor)
        }
    }

    /** The amount of energy to add back into the system. [Default Value: 0] */
    var energyReturn: AKParameter = akp(0) {
        didSet {
            energyReturn.bind(&drip.memory.shake_max, right:&drip2.memory.shake_max)
            dependencies.append(energyReturn)
        }
    }

    /** Main resonant frequency. [Default Value: 450] */
    var mainResonantFrequency: AKParameter = akp(450) {
        didSet {
            mainResonantFrequency.bind(&drip.memory.freq, right:&drip2.memory.freq)
            dependencies.append(mainResonantFrequency)
        }
    }

    /** The first resonant frequency. [Default Value: 600] */
    var firstResonantFrequency: AKParameter = akp(600) {
        didSet {
            firstResonantFrequency.bind(&drip.memory.freq1, right:&drip2.memory.freq1)
            dependencies.append(firstResonantFrequency)
        }
    }

    /** The second resonant frequency. [Default Value: 750] */
    var secondResonantFrequency: AKParameter = akp(750) {
        didSet {
            secondResonantFrequency.bind(&drip.memory.freq2, right:&drip2.memory.freq2)
            dependencies.append(secondResonantFrequency)
        }
    }

    /** Amplitude. [Default Value: 0.3] */
    var amplitude: AKParameter = akp(0.3) {
        didSet {
            amplitude.bind(&drip.memory.amp, right:&drip2.memory.amp)
            dependencies.append(amplitude)
        }
    }


    // MARK: - Initializers

    /** Instantiates the droplet with default values

    - parameter input: Triggering input, such as a metronome. 
    */
    init(input sourceInput: AKParameter)
    {
        super.init()
        input = sourceInput
        setup()
        dependencies = [input]
        bindAll()
    }

    /** Instantiates droplet with constants

    - parameter input: Triggering input, such as a metronome. 
    - parameter maximumDuration: Period of time over which all sound is stopped. [Default Value: 0.09]
    */
    init (input sourceInput: AKParameter, maximumDuration dettackInput: Float) {
        super.init()
        input = sourceInput
        setup(dettackInput)
        dependencies = [input]
        bindAll()
    }

    /** Instantiates the droplet with all values

    - parameter input: Triggering input, such as a metronome. 
    - parameter intensity: Number of units. The intensity of the dripping sound. [Default Value: 10]
    - parameter dampingFactor: The damping factor. Maximum value is 2.0. [Default Value: 0.2]
    - parameter energyReturn: The amount of energy to add back into the system. [Default Value: 0]
    - parameter mainResonantFrequency: Main resonant frequency. [Default Value: 450]
    - parameter firstResonantFrequency: The first resonant frequency. [Default Value: 600]
    - parameter secondResonantFrequency: The second resonant frequency. [Default Value: 750]
    - parameter amplitude: Amplitude. [Default Value: 0.3]
    - parameter maximumDuration: Period of time over which all sound is stopped. [Default Value: 0.09]
    */
    convenience init(
        input                   sourceInput:    AKParameter,
        intensity               num_tubesInput: AKParameter,
        dampingFactor           dampInput:      AKParameter,
        energyReturn            shake_maxInput: AKParameter,
        mainResonantFrequency   freqInput:      AKParameter,
        firstResonantFrequency  freq1Input:     AKParameter,
        secondResonantFrequency freq2Input:     AKParameter,
        amplitude               ampInput:       AKParameter,
        maximumDuration         dettackInput:   Float)
    {
        self.init(input: sourceInput, maximumDuration: dettackInput)
        intensity               = num_tubesInput
        dampingFactor           = dampInput
        energyReturn            = shake_maxInput
        mainResonantFrequency   = freqInput
        firstResonantFrequency  = freq1Input
        secondResonantFrequency = freq2Input
        amplitude               = ampInput

        bindAll()
    }

    // MARK: - Internals

    /** Bind every property to the internal droplet */
    internal func bindAll() {
        intensity              .bind(&drip.memory.num_tubes, right:&drip2.memory.num_tubes)
        dampingFactor          .bind(&drip.memory.damp, right:&drip2.memory.damp)
        energyReturn           .bind(&drip.memory.shake_max, right:&drip2.memory.shake_max)
        mainResonantFrequency  .bind(&drip.memory.freq, right:&drip2.memory.freq)
        firstResonantFrequency .bind(&drip.memory.freq1, right:&drip2.memory.freq1)
        secondResonantFrequency.bind(&drip.memory.freq2, right:&drip2.memory.freq2)
        amplitude              .bind(&drip.memory.amp, right:&drip2.memory.amp)
        dependencies.append(intensity)
        dependencies.append(dampingFactor)
        dependencies.append(energyReturn)
        dependencies.append(mainResonantFrequency)
        dependencies.append(firstResonantFrequency)
        dependencies.append(secondResonantFrequency)
        dependencies.append(amplitude)
    }

    /** Internal set up function */
    internal func setup(maximumDuration: Float = 0.09) {
        sp_drip_create(&drip)
        sp_drip_create(&drip2)
        sp_drip_init(AKManager.sharedManager.data, drip, maximumDuration)
        sp_drip_init(AKManager.sharedManager.data, drip2, maximumDuration)
    }

    /** Computation of the next value */
    override func compute() {
        sp_drip_compute(AKManager.sharedManager.data, drip, &(input.leftOutput), &leftOutput);
        sp_drip_compute(AKManager.sharedManager.data, drip2, &(input.rightOutput), &rightOutput);
    }

    /** Release of memory */
    override func teardown() {
        sp_drip_destroy(&drip)
        sp_drip_destroy(&drip2)
    }
}
